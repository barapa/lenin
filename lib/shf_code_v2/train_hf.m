function [theta, results, params] = train_hf(X, Y, testX, testY, params, theta)

    % Main (outer) function for stochastic HF
    addpath('code');
    
    % Layer properties
    for i = 1:length(params.arch)
        params.layers(i).len = params.arch(i);
        params.layers(i).actfun = params.activations{i};
    end
    
    % Initialize the network
    [m, params.inputsize] = size(X);
    if ~exist('theta', 'var') || isempty(theta)
        theta = initialize(params);
    end

    % Numparams
    numparams = length(theta);
    params.numparams = numparams;

    % Mask (determine which weights to apply L2 penalty)
    mask = ones(numparams, 1);
    [maskW, maskb] = unpacknet(mask, params.layers, params.inputsize);
    for i = 1:length(maskb)
        maskb{i}(:) = 0;
    end
    params.mask = packnet(maskW, maskb);

    % Set some variables
    ch = zeros(params.numparams, 1);
    obj_record = zeros(params.maxepoch * ceil(m ./ params.gradbatchsize), 1);
    train_err_record = zeros(params.maxepoch * ceil(m ./ params.gradbatchsize), 1);
    test_err_record = zeros(params.maxepoch * ceil(m ./ params.gradbatchsize), 1);
    totalpasses = 0;
    epoch = 1;
    decrease = 0.99;
    boost = 1 / decrease;

    params.numpts = m;
    params.lambda = 0.1;
    params.weight_cost = 2e-7;
    params.decay = 0.5;
    params.conj_miniters = 1;
    params.conj_maxiters = 5;
    params.dropout(1) = params.corruption;
    
    % Hidden layer dropout. Only use for classification
    if strcmp(params.type, 'classification')
        params.dropout(2) = 0.5;
    elseif strcmp(params.type, 'autoencoder')
        params.dropout(2) = 0;
    end
    
    % Flags 
    params.computeObj = 0;
    params.computeGrad = 0;
    params.computeGV = 0;
    params.computePrecon = 0;
    params.computeFP = 0;
    params.test = 0;

%------------------------------------------------------------------------------------------

    % Pre-compute batches
    batchsize = params.batchsize;
    gradbatchsize = params.gradbatchsize;
    verbose = ceil(m ./ gradbatchsize);

    numbatches = ceil(m ./ gradbatchsize);
    index = randperm(m);
    gradbatchesX = cell(numbatches, 1);
    gradbatchesY = cell(numbatches, 1);
    for i = 1:numbatches
        gradbatchesX{i} = X(index((i-1) * gradbatchsize + 1 : min([i * gradbatchsize end])), :);
        gradbatchesY{i} = Y(index((i-1) * gradbatchsize + 1 : min([i * gradbatchsize end])), :);
    end
    f = 1;
    iter = 1;
    
%------------------------------------------------------------------------------------------

    % Main Loop
    % The notation here is kind of confusing: the variable 'epoch' should really be 'iteration'
    % This is all a consequence of modifying my original batch HF code
    for epoch = epoch : params.maxepoch * ceil(m ./ params.gradbatchsize)

        % Start of new epoch
        if mod(epoch - 1, ceil(m ./ gradbatchsize)) + 1 == 1
            disp(' ');
            disp([' - epoch ' num2str(iter) ' of ' num2str(ceil(params.maxepoch)) '...']);
            if epoch > 1
                f = f * 0.998;
                if params.decay < 0.99
                    params.decay = min(params.decay * 1.01, 0.99);
                end
            end
        end

        fprintf('.');
        
        epochmod = mod(epoch - 1, ceil(m ./ gradbatchsize)) + 1;
        gradbatchX = gradbatchesX{epochmod};
        gradbatchY = gradbatchesY{epochmod};

        % Pre-compute dropout units
        if params.dropout(2) > 0 && length(params.layers) > 1
            params.drop = rand(size(gradbatchX, 1), params.layers(end-1).len) > params.dropout(2);
        end       

        % Corrupt the input (if applicable)
        if params.dropout(1) > 0
            gradbatchX(rand(size(gradbatchX)) < params.dropout(1)) = 0;
        end

        cepochmod = mod(iter - 1, ceil(gradbatchsize ./ batchsize)) + 1;
        batchX = gradbatchX((cepochmod - 1) * batchsize + 1 : min([cepochmod * batchsize end]), :);
        batchY = gradbatchY((cepochmod - 1) * batchsize + 1 : min([cepochmod * batchsize end]), :); 

        if params.dropout(2) > 0 && length(params.layers) > 1
            params.drop_batch = params.drop((cepochmod - 1) * batchsize + 1 : min([cepochmod * batchsize end]), :);
            params.drop_gradbatch = params.drop;
        end      

%---------------------------------------------------------------------------------------------

        % Compute gradient and pre-conditioner
        params.computeObj = 1;
        params.computeGrad = 1;
        params.computePrecon = 1;
        [obj_PREV, grad, precon] = hf(theta, gradbatchX, gradbatchY, params);
        grad = -grad;
        params.computeGrad = 0;
        params.computePrecon = 0;
        params.computeObj = 0;
     
%---------------------------------------------------------------------------------------------
       
        % Decay the previous conjgrad vector
        ch = ch * params.decay;
        
        % Conjugate gradient
        params.computeFP = 1;
        params.acts = hf(theta, batchX, batchY, params);
        params.computeFP = 0;

        % Apply conjugate gradient
        [chs, iterses] = conjgrad(@hf, grad, ch, params.conj_miniters, params.conj_maxiters, theta, batchX, batchY, params, precon);

        ch = chs{end};
        iters = iterses(end);
        totalpasses = totalpasses + iters;
        p = ch;

%----------------------------------------------------------------------------------------------

        % CG-Backtracking
        j = length(chs);

        params.computeObj = 1;

        obj = hf(theta + p, gradbatchX, gradbatchY, params);

        for j = (length(chs) - 1): -1 : 1
            obj_chs = hf(theta + chs{j}, gradbatchX, gradbatchY, params);
            if obj < obj_chs
                j = j + 1;
                break
            end
            obj = obj_chs;
        end
        if isempty(j)
            j = 1;
        end
        p = chs{j};

%-----------------------------------------------------------------------------------------------

        % Reduction ratio computation
        params.computeObj = 0;
        params.computeGV = 1;
        curr_lambda = params.lambda;
        params.lambda = 0;

        denom = 0.5 * (chs{j}' * hf(theta, batchX, batchY, params, chs{j}, params.acts));
        denom = denom - grad' * chs{j};

        params.lambda = curr_lambda;
        params.computeGV = 0;

        rho = (obj - obj_PREV) ./ denom;
        if obj - obj_PREV > 0
            rho = -Inf;
        end

%------------------------------------------------------------------------------------------------

        % Linesearch
        rate = 1;
        c = 10^(-2);
        j = 0;
        while j < 60
            if obj <= obj_PREV + c * rate * (grad' * p)
                break;
            else
                rate = 0.8 * rate;
                j = j + 1;
            end

            params.computeObj = 1;
            obj = hf(theta + rate * p, gradbatchX, gradbatchY, params);
            params.computeObj = 0;
        end

        % Reject the step
        if j == 60          
            fprintf('R');
            j = Inf;
            rate = 0;
            obj = obj_PREV;           
        end

%-----------------------------------------------------------------------------------------------
       
        % Update lambda
        if rho < 0.25 || isnan(rho)
            params.lambda = params.lambda * boost;
        elseif rho > 0.75
            params.lambda = params.lambda * decrease;
        end

%------------------------------------------------------------------------------------------------

        % Update parameters
        theta = theta + f * rate * p;
        theta = maxnorm(theta, params);
        obj_record(epoch) = obj;

        % Compute error
        if strcmp(params.type, 'classification')

            % Training error
            params.test = 1;
            netout = map(theta, X, params);
            [foo, train_L] = max(Y, [], 2);
            [foo, yhat] = max(netout, [], 2);
            train_err_record(epoch) = sum(train_L ~= yhat) ./ length(yhat);
            params.test = 0;

            % Test error
            if exist('testX','var') && ~isempty(testX)
                params.test = 1;
                netout = map(theta, testX, params);
                [foo, test_L] = max(testY, [], 2);
                [foo, yhat] = max(netout, [], 2);
                test_err_record(epoch) = sum(test_L ~= yhat) ./ length(yhat);           
                params.test = 0;
            end
        
        elseif strcmp(params.type, 'autoencoder')   

            yhat = map(theta, X, params);
            train_err_record(epoch) = 0.5 * sum(sum((yhat - Y) .^ 2)) ./ size(Y, 1);
            if exist('testX','var') && ~isempty(testX)
                yhat = map(theta, testX, params);
                test_err_record(epoch) = 0.5 * sum(sum((yhat - testY) .^ 2)) ./ size(testY, 1);
            end

        end

        % Results
        if mod(epoch, ceil(m ./ gradbatchsize)) == 0
            results.train_error(iter) = train_err_record(epoch);
            results.test_error(iter) = test_err_record(epoch);
            results.lambda(iter) = params.lambda;
            iter = iter + 1;
            
            if mod(epoch, params.verbose * ceil(m ./ gradbatchsize)) == 0 ...
                    && strcmp(params.type, 'classification')
                disp(' ');
                disp(['train error: ' num2str(train_err_record(epoch))]);
                if exist('testX','var') && ~isempty(testX)
                    disp(['test error: ' num2str(test_err_record(epoch))]);
                end
                disp(['lambda: ' num2str(params.lambda)]);
            end
            
            if mod(epoch, params.verbose * ceil(m ./ gradbatchsize)) == 0 ...
                    && strcmp(params.type, 'autoencoder')
                disp(' ');
                disp(['train MSE: ' num2str(train_err_record(epoch))]);
                if exist('testX','var') && ~isempty(testX)
                    disp(['test MSE: ' num2str(test_err_record(epoch))]);
                end
                disp(['lambda: ' num2str(params.lambda)]);
            end
                       
        end

    end


        
       

function varargout = hf(theta, X, Y, params, v, acts)

% Inner function for stochastic HF

% Outputs: C, grad, gv, precon, acts

    % Parameter values
    layers = params.layers;
    weight_cost = params.weight_cost;
    mask = params.mask;
    lambda = params.lambda;
    objfun = params.objfun;
    numparams = params.numparams;

    computeObj = params.computeObj;
    computeGrad = params.computeGrad;
    computeGV = params.computeGV;
    computePrecon = params.computePrecon;
    computeFP = params.computeFP;

    [m, n] = size(X);
    no_layers = length(layers);

    % Unpack
    [W, b] = unpacknet(theta, layers, n);

%-----------------------------------------------------------------------------------------------

    % Forward pass
    if ~exist('acts', 'var') 

        % Run data through network
        acts = cell(1, no_layers + 1);
        acts{1} = [X ones(m, 1)];
        for i = 1:no_layers
            
            switch layers(i).actfun
                case 'logistic'
                    acts{i + 1} = [1 ./ (1 + exp(-(acts{i} * [W{i}; b{i}]))) ones(m, 1)];
                case 'ReLU'
                    acts{i + 1} = [max(acts{i} * [W{i}; b{i}], 0) ones(m, 1)];
                case 'linear'
                    acts{i + 1} = [acts{i} * [W{i}; b{i}] ones(m, 1)];
                case 'softmax'
                    layerinput = acts{i} * [W{i}; b{i}];
                    acts{i + 1} = exp(bsxfun(@minus, layerinput, max(layerinput, [], 2)));
                    acts{i + 1} = [bsxfun(@rdivide, acts{i + 1}, sum(acts{i + 1}, 2)) ones(m, 1)];
                otherwise
                    disp('Activation not supported');
            end

            % Dropout
            if params.dropout(2) > 0 && i == no_layers - 1 && params.test == 0
                if computeObj || computeGrad
                    acts{i+1}(:,1:end-1) = acts{i+1}(:,1:end-1) .* params.drop_gradbatch;
                elseif computeGV && size(acts{i+1}(:,1:end-1), 1) == size(params.drop_gradbatch, 1)
                    acts{i+1}(:,1:end-1) = acts{i+1}(:,1:end-1) .* params.drop_gradbatch;
                elseif computeGV
                    acts{i+1}(:,1:end-1) = acts{i+1}(:,1:end-1) .* params.drop_batch;
                end
            end

        end
    end

%-------------------------------------------------------------------------------------------------

    % Compute objective
    if computeObj || computeGrad

        % Compute objective function
        switch objfun
            case 'MSE'
                C = 0.5 * sum(sum((acts{end}(:,1:end - 1) - Y) .^ 2)) ./ m;
            case 'cross-entropy'
                C = -sum(sum(Y .* log(acts{end}(:,1:end-1) + realmin) + (1 - Y) .* log(1 - acts{end}(:,1:end-1) + realmin))) ./ m;
            case 'softmax-entropy'
                C = -sum(sum(Y .* log(acts{end}(:,1:end-1) + realmin))) ./ m;
            otherwise
                disp('Objective not supported');
        end

        % Weight cost
        C = C + (0.5 * weight_cost) * sum((mask .* theta) .^2);
    end

%---------------------------------------------------------------------------------------------------

    % Backward pass
    if computeGrad

        dW = cell(1, no_layers);
        db = cell(1, no_layers);
        if computePrecon
            dW2 = cell(1, no_layers);
            db2 = cell(1, no_layers);
        end

        % Assumes matching loss
        Ix = (acts{end}(:,1:end - 1) - Y) ./ m;

        % Backprop
        for i = no_layers : -1 : 1
         
            % Compute update
            delta = acts{i}' * Ix;
            dW{i} = delta(1:end - 1, :);
            db{i} = delta(end, :);

            if computePrecon
                delta2 = m * (acts{i}').^2 * Ix .^2;
                dW2{i} = delta2(1:end - 1, :);
                db2{i} = delta2(end, :);
            end

            if i > 1
                switch layers(i-1).actfun
                    case 'logistic'
                        Ix = (Ix * [W{i}; b{i}]') .* acts{i} .* (1 - acts{i});
                    case 'ReLU'
                        Ix = Ix * [W{i}; b{i}]' .* (acts{i} > 0);
                    case 'linear'
                        Ix = Ix * [W{i}; b{i}]';
                    otherwise
                        disp('Activation not supported');
                end
                Ix = Ix(:,1:end - 1);
            end
        end

        % Compute gradient and preconditioner
        grad = packnet(dW, db);
        grad = grad + weight_cost * (mask .* theta);
        if computePrecon
            precon = packnet(dW2, db2);
            precon = (precon + ones(numparams, 1) * lambda + weight_cost * mask) .^ (3.0 / 4.0);
        end
    end

%---------------------------------------------------------------------------------------------------

    % Compute Gauss-Newton vector product
    if computeGV

        % Initialize
        R = cell(1, no_layers + 1);
        bz = cell(1, no_layers + 1);
        R{1} = zeros(m, n+1);

        % Unpack vector
        [VW, Vb] = unpacknet(v, layers, n);

        % R-Operator forward pass
        for i = 1:no_layers

            bz{i} = zeros(size(b{i}));
            R{i + 1} = [R{i} * [W{i}; bz{i}] zeros(m, 1)] + [acts{i} * [VW{i}; Vb{i}] ones(m, 1)];
            
            if strcmp(layers(i).actfun, 'logistic')
                R{i + 1} = R{i + 1} .* acts{i+1} .* (1 - acts{i+1});
            elseif strcmp(layers(i).actfun, 'ReLU')
                R{i + 1} = R{i + 1} .* (acts{i+1} > 0);
            elseif strcmp(layers(i).actfun, 'softmax')
                R{i + 1} = R{i + 1} .* acts{i+1} - bsxfun(@times, acts{i+1}, sum(acts{i+1}(:,1:end-1) .* R{i+1}(:,1:end-1), 2));
            end
        end
        RIx = R{end}(:, 1:end - 1) ./ m;
        
        % Backprop
        for i = no_layers : - 1 : 1
 
            % Compute update
            delta = acts{i}' * RIx;
            dVW{i} = delta(1:end - 1, :);
            dVb{i} = delta(end, :);

            if i > 1
                switch layers(i-1).actfun
                    case 'logistic'
                        RIx = (RIx * [W{i}; b{i}]') .* acts{i} .* (1 - acts{i});
                    case 'ReLU'
                        RIx = RIx * [W{i}; b{i}]' .* (acts{i} > 0);
                    case 'linear'
                        RIx = RIx * [W{i}; b{i}]';
                    otherwise
                        disp('Activation not supported');
                end
                RIx = RIx(:,1:end - 1);
            end 
        end

        % Compute product
        gv = packnet(dVW, dVb);
        gv = gv + weight_cost * (mask .* v);
        gv = gv + lambda * v;
    end
         
 %---------------------------------------------------------------------------------------------------               
        
    % Return variables
    varargout = {};
    if computeObj
        varargout{end + 1} = C;
    end
    if computeGrad
        varargout{end + 1} = grad;
    end
    if computeGV
        varargout{end + 1} = gv;
    end
    if computePrecon
        varargout{end + 1} = precon;
    end
    if computeFP
        varargout{end + 1} = acts;
    end





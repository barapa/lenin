function [y, code] = map(theta, X, params, lin)

    % Map the data using the network
    % lin: stop at linear (used for Gauss-Newton checker)

    if ~exist('lin', 'var') || isempty(lin)
        lin = 0;
    end
    layers = params.layers;
    dropout = params.dropout;

    [m, n] = size(X);
    [W, b] = unpacknet(theta, layers, n);
    no_layers = length(layers);

    % Drop the input weights
    if dropout(1) > 0
        W{1} = W{1} * (1 - params.dropout(1));
    end

    % Drop all the outgoing weights
    if dropout(2) > 0
        for i = 2:no_layers
            W{i} = W{i} * (1 - params.dropout(2));
        end
    end

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
        if i == no_layers && lin
            acts{i + 1} = [acts{i} * [W{i}; b{i}] ones(m, 1)];
        end
      
    end
    y = acts{end}(:,1:end-1);
    if strcmp(params.type, 'autoencoder')
        code = acts{(no_layers / 2) + 1}(:,1:end-1);
    end


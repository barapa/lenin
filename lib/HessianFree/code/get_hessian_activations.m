% function [y, acts, code] = get_hessian_activations(theta, X, params)
% This is a modified version of the map function. This version returns the
% entire activation of the network with a given input.
%
% theta:  A vector representing all of the params learned by a trained
%         network. This is output by the hessian_free_train function and
%         is called paramsp.
% X:      An DxN matrix of inputs to put through the network to get out
%         their activations
% layersizes: 
%         A vector containing the sizes of every layer of the network,
%         including the input and output layer. This is already returned by
%         the hessian_free_call function.
% layertypes:
%         A 1 x L-1 cell array of strings indicating the type of layers
%
% acts:   A 1 x L cell array, where L is the number of layers, INCLUDING
%         the input layer, of the activations at each layer.
%         Each matrix is N x Nodes_in_layer + 1, since it includes a 1 node
%         for the bias. The last matrix matches up with y, except for the
%         added bias node.
% y:      An N x K matrix, where K is the number of nodes in the last layer,
%         ie, the number of classes for a classifier, that represents the 
%         output of the final layer of the network for each N inputs in X.
function [acts, y] = get_hessian_activations(theta, X, layersizes, layertypes)

    % Map the data using the network
    layers = layersizes;
    X = X'; % switch to NxD for the stupid function.

    [m, n] = size(X);
    [W, b] = unpacknet_hessian(theta, layers); 
    no_layers = numel(layers);

    % Run data through network
    acts = cell(1, no_layers);
    acts{1} = [X ones(m, 1)];
    for i = 1:no_layers-1

        switch layertypes{i}
            case 'logistic'
                acts{i + 1} = [1 ./ (1 + exp(-(acts{i} * [W{i}; b{i}]))) ones(m, 1)];
            case 'ReLU'
                error('No ReLU nodes available');
                %acts{i + 1} = [max(acts{i} * [W{i}; b{i}], 0) ones(m, 1)];
            case 'linear'
                acts{i + 1} = [acts{i} * [W{i}; b{i}] ones(m, 1)];
            case 'softmax'
                layerinput = acts{i} * [W{i}; b{i}];
                acts{i + 1} = exp(bsxfun(@minus, layerinput, max(layerinput, [], 2)));
                acts{i + 1} = [bsxfun(@rdivide, acts{i + 1}, sum(acts{i + 1}, 2)) ones(m, 1)];
            otherwise
                disp('Activation not supported');
        end

    end
    y = acts{end}(:,1:end-1);


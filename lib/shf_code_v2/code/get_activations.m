% function [y, acts, code] = get_activations(theta, X, params)
% This is a modified version of the map function. This version returns the
% entire activation of the network with a given input.
%
% theta:  A vector representing all of the params learned by a trained
%         network. This is output by the hf_train function.
% X:      An NxD matrix of inputs to put through the network to get out
%         their activations
% params: A params object, as output by a trained network, that contains
%         the params necessary to reconstruct the topology of the network.
%
% y:      An N+1 x K matrix, where K is the number of nodes in the last layer,
%         ie, the number of classes for a classifier, that represents the 
%         output of the final layer of the network for each N inputs in X.
% acts:   A 1 x L cell array, where L is the number of layers, INCLUDING
%         the input layer, of the activations at each layer.
%         Each matrix is N+1 x Nodes_in_layer, since it includes a 1 node
%         for the bias. The last matrix matches up with y, except for the
%         added bias node.
% code:   is the code learned for a denoising autoencoder. Only include if
%         getting output of denoising autoencoder.
function [y, acts, code] = get_activations(theta, X, params)

    % Map the data using the network

    lin = 0;
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


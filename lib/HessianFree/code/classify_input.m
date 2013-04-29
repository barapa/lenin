% function [predictions] = classify_input(theta, input, layersizes, layertypes)
% Takes the params of a trained network that has a final SOFTMAX layer, and makes
% predictions for the given output by returning a one-hot matrix of predictions.

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
% predictions: An K x N array of one-hot labels given to the input by the network

function [predictions] = classify_input(theta, input, layersizes, layertypes)
  [~, y] = get_hessian_activations(theta, input, layersizes, layertypes);
  % set max activation to one and all others to 0

  % just loop through because I can't figure out a better way
  [~, max_inds] = max(y, [], 2);
  predictions = zeros(size(y));
  for i = 1 : size(y, 1)
    predictions(i, max_inds(i)) = 1;
  end

  predictions = predictions'; % NxK -> KxN


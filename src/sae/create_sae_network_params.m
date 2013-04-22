% function [ training_params ] = create_sae_network_params(layer_sizes)
%
% create_dbn_network_params is a helper function to create the
% network parameters object used to pretrain a dbn. 
%
% layer_sizes: a 1 x num_hidden_layers vector where each element is the
%              number of nodes in the corresponding hidden layer. The first
%              element corresponds to the layer closest to the visible layer.
%
% activation_function:
%             'sigm' is the only allowable one for now

function [ network_params ] = create_sae_network_params(...
  layer_sizes, activation_function)

network_params.sizes = layer_sizes;
network_params.activation_function = activation_function;

end


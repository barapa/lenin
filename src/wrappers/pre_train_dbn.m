function [ output_args ] = pre_train_dbn( network_params,...
    training_params, files_to_train )
%pre_train_dbn Summary of this function goes here
%   Detailed explanation goes here
%
% network_params: Object containing all of the DBN network parameters.'
%
%   network_params.layer_sizes: 
%       a 1 x n vector of scalars where each scalar value is the number of
%       nodes in that hidden layer. The size of the visible layer is NOT
%       specified
%
%
% training_params: Object containing the training parameters for the
%                  pre-training phase
%
%   training_params.num_epochs:
%       A scalar. The number of training epochs to perform on each RBM
%       training
%   training_params.song_batch_size:
%       A scalar. The number of songs to concatenate into one and train the
%       DBN on at a time. This is at a higher level than epochs and 
%       minibatches.
%   training_params.mini_batch_size:
%       A scalar. The number of frames to use when training an RBM layer.
%       This is the normal meaning of the batchsize parameter, as described
%       in the literature
%   training_params.momentum:
%       A scalar value between 0 and 1. The momentum used in training the
%       DBN for updating the weights.
%   training_params.learning_rate:
%       A small scalar value, e.g., 0.05. The learning rate.



end


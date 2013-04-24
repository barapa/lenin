function [ training_params ] = create_dbn_pre_training_params(...
    num_epochs, song_batch_size, mini_batch_size, momentum,...
    gaussian_learning_rate, binary_learning_rate, cdk )
% function [ training_params ] = create_dbn_pre_training_params(...
%    num_epochs, song_batch_size, mini_batch_size, momentum, learning_rate )
%
% create_dbn_pre_training_params is a helper function to create the
% training parameters object used to pretrain a dbn. Descriptions of the
% inputs can be found in pre_train_dbn().

training_params.num_epochs = num_epochs;
training_params.song_batch_size = song_batch_size;
training_params.mini_batch_size = mini_batch_size;
training_params.momentum = momentum;
training_params.gaussian_learning_rate = gaussian_learning_rate;
training_params.binary_learning_rate = binary_learning_rate;
training_params.cdk = cdk;

end


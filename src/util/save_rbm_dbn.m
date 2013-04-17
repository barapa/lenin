% function [ filename ] = save_rbm_dbn( dbn, dbn_training_params,...
%     dbn_network_params, preprocessing_params, train_dbn_songs,...
%     train_nn_songs, test_nn_songs, nn, nn_training_params)
% 
% Saves a fully trained deep belief network and neural network to be used
% and analyzed later.
% 
% All variables not listed below are the standard variables as described
% elsewhere.
% 
% train_dbn_songs: cell array of song path_names that were used to pretrain
%                  the dbn
% train_nn_songs:  cell array of song path_names that were used to train the
%                  feed forward neural network with back propogation
% test_nn_songs:   cell arary of song path_names that were used to test the
%                  output of the neural net for classification. Can be left
%                  by passing in an empty cell array.
% error_rate:      number indicating the error rate on the testing set from
%                  training the ffnn
%
function [ filename ] = save_rbm_dbn( dbn, dbn_training_params,...
    dbn_network_params, preprocessing_params, train_dbn_songs,...
    train_nn_songs, test_nn_songs, nn, nn_training_params, error_rate)

save_dir = '/var/data/lenin/rbm_dbn_models/';
mkdir(save_dir);

filename = [save_dir, 'rbm_dbm', datestr(now, 'yyyymmddTHHMMSS')];

save(filename,...
    'dbn', 'dbn_training_params', 'dbn_network_params', 'preprocessing_params',...
    'train_dbn_songs', 'train_nn_songs', 'test_nn_songs', 'nn', 'nn_training_params',...
    'error_rate');

end


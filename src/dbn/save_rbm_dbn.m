% function [ filename ] = save_rbm_dbn( dbn, dbn_training_params,...
%     dbn_network_params, train_dbn_songs, train_nn_songs,...
%     test_nn_songs, nn, nn_training_params, preprocessing_params)
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
% filename : returned value is the filename of the saved model, without the
%            path. Example: 'rbm_dbn_20130417T123919.mat'
%
function [ filename ] = save_rbm_dbn( dbn, dbn_training_params,...
    dbn_network_params, train_dbn_songs, train_nn_songs,...
    test_nn_songs, nn, nn_training_params, error_rate, preprocessing_params)

save_dir = '/var/data/lenin/rbm_dbn_models/';
ensure_dir_exists(save_dir);

filename = ['rbm_dbn_', datestr(now, 'yyyymmddTHHMMSS')];
file_path = [save_dir, filename];

if exist('preprocessing_params')
  save(file_path,...
      'dbn', 'dbn_training_params', 'dbn_network_params', 'preprocessing_params',...
      'train_dbn_songs', 'train_nn_songs', 'test_nn_songs', 'nn', 'nn_training_params',...
      'error_rate');
else
  save(file_path,...
      'dbn', 'dbn_training_params', 'dbn_network_params', 'train_dbn_songs',...
      'train_nn_songs', 'test_nn_songs', 'nn', 'nn_training_params',...
      'error_rate');
end

filename = [filename '.mat'];

end


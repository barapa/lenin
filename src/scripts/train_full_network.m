% This is an example script to show you how to call the wrapper for training
% a DBN and NN.

% TODO(ben): replace this with reading from sams variables
% get list of song data with full path names
songs_list = fuf('/var/data/lenin/matlab/*.mat', 'detail');
train_dbn_songs = songs_list(1:80);
validate_nn_songs = songs_list(101:110);
test_nn_songs = songs_list(111:120);

% DEEP BELIEF NETWORK

% network topology
layer_sizes = [1000, 500, 200];
gaussian_vis_layer = 1;
dbn_network_params = create_dbn_network_params(layer_sizes, gaussian_vis_layer);

% training parameters
num_epochs = 20;
song_batch_size = 10;
mini_batch_size = 100;
momentum = .5;
gaussian_learning_rate = .0001;
binary_learning_rate = .1;
dbn_training_params = create_dbn_pre_training_params(num_epochs,...
    song_batch_size, mini_batch_size, momentum,...
    gaussian_learning_rate, binary_learning_rate);

% preprocessing
epsilon = 0.00001;
k = 250;
preprocessing_params = create_dbn_pre_processing_params(epsilon, k);

% train the dbn
[dbn, preprocessing_params] = pre_train_dbn(dbn_network_params,...
    dbn_training_params, train_dbn_songs, preprocessing_params);

% ------------------------------------------------%
% FEED FORWARD NEURAL NETWORK

% load data and whiten
% training data
[train_nn_x, train_nn_song_borders, train_nn_y] = load_songs(train_dbn_songs);
train_nn_x = whiten_data(train_nn_x, preprocessing_params.X_avg,...
    preprocessing_params.W);
% validation data
[validate_nn_x, validate_nn_song_borders, validate_nn_y] = load_songs(validate_nn_songs);
validate_nn_x = whiten_data(validate_nn_x, preprocessing_params.X_avg,...
    preprocessing_params.W);
% testing data
[test_nn_x, test_nn_song_borders, test_nn_y] = load_songs(test_nn_songs);
test_nn_x = whiten_data(test_nn_x, preprocessing_params.X_avg,...
    preprocessing_params.W);

% training params
nn_num_epochs = 50;
nn_batch_size = 100;
nn_plot = 1;
nn_training_params = create_nn_training_params(nn_num_epochs, nn_batch_size, nn_plot);

% train
activation_function = 0; % 0 for sigm, 1 for tanh_opt
nn = train_nn(dbn, train_nn_x, train_nn_y, nn_training_params, activation_function,...
  validate_nn_x, validate_nn_y);

% test
[err, bad] = nntest(nn, test_nn_x', test_nn_y');

save_rbm_dbn(dbn, dbn_training_params, dbn_network_params, preprocessing_params,...
    train_dbn_songs, train_nn_songs, test_nn_songs, nn, nn_training_params);

% This is an example script to show you how to call the wrapper for pretraining
% a DBN. The basic idea is to use the utility functions used below to create
% the parameter objects for the network and the training, and to pass that
% along with the list of filenames that hold the data to the training
% wrapper.

% TODO(ben): replace this with reading from sams variables
% get list of song data with full path names
songs_list = fuf('/var/data/lenin/matlab/*.mat', 'detail');
train_dbn_songs = songs_list(1:5);
train_nn_songs = songs_list(21:25);
test_nn_songs = songs_list(26:30);

% DEEP BELIEF NETWORK

% network topology
layer_sizes = [500, 100];
gaussian_vis_layer = 1;
network_params = create_dbn_network_params(layer_sizes, gaussian_vis_layer);

% training parameters
num_epochs = 2;
song_batch_size = 2;
mini_batch_size = 100;
momentum = .5;
learning_rate = .0001;
training_params = create_dbn_pre_training_params(num_epochs,...
    song_batch_size, mini_batch_size, momentum, learning_rate);

% preprocessing
epsilon = 0.00001;
k = 250;
[ preprocessing_params ] = create_dbn_pre_processing_params(epsilon, k);

% train the dbn
dbn = pre_train_dbn(network_params, training_params, train_dbn_songs, preprocessing_params);

% ------------------------------------------------%
% FEED FORWARD NEURAL NETWORK

% data
[train_nn_x, train_nn_song_borders, train_nn_y] = load_songs(train_nn_songs, preprocessing_params);
[test_nn_x, test_nn_song_borders, test_nn_y] = load_songs(test_nn_songs, preprocessing_params);

% training params
nn_num_epochs = 2;
nn_batch_size = 100;
nn_plot = 1;
nn_training_params = create_nn_training_params(nn_num_epochs, nn_batch_size, nn_plot);

% train
activation_function = 0; % 0 for sigm, 1 for tanh_opt
nn = train_nn(dbn, train_nn_x, train_nn_y, nn_training_params, activation_function);

% test
[err, bad] = nntest(nn, test_nn_x', test_nn_y');

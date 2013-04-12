total_songs = 10;

% network topology
layer_sizes = [100, 100];
network_params = create_dbn_network_params(layer_sizes);

% training parameters
num_epochs = 100;
song_batch_size = 1;
mini_batch_size = 100;
momentum = 0;
learning_rate = .5;
training_params = create_dbn_pre_training_params(num_epochs,...
    song_batch_size, mini_batch_size, momentum, learning_rate);

% get list of song data with full path names
songs_list = fuf('/var/data/lenin/matlab/*.mat', 'detail');
songs_list = songs_list(1:total_songs);

dbn = pre_train_dbn(network_params, training_params, songs_list);
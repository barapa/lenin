% get list of song data with full path names
songs_list = fuf('/var/data/lenin/matlab/*.mat', 'detail');
songs_list = songs_list(1:10);
%songs_list = songs_list(1:total_songs);


% network topology
layer_sizes = [100, 100];
gaussian_vis_layer = 1;
network_params = create_dbn_network_params(layer_sizes, gaussian_vis_layer);

% training parameters
num_epochs = 100;
song_batch_size = 1;
mini_batch_size = 100;
momentum = .5;
learning_rate = .5;
training_params = create_dbn_pre_training_params(num_epochs,...
    song_batch_size, mini_batch_size, momentum, learning_rate);

dbn = pre_train_dbn(network_params, training_params, songs_list);
% data
run = 1;
window_size = 2048;
window_overlap = 1024;
preprocessing_epsilon = .00001;
preprocessing_k = 256;   
% dbn
dbn_train_percentage = 60;
dbn_layer_sizes = [750, 300];
dbn_is_visible_layer_gaussian = 1;
dbn_num_epochs = 100;
dbn_song_batch_size = 10;
dbn_mini_batch_size = 100;
dbn_momentum = .7;
dbn_binary_learning_rate = .01;
dbn_gaussian_learning_rate = .0003;
% nn
nn_train_percentage = 30;
nn_num_epochs = 100;
nn_batch_size = 100;
nn_learning_rate = 1;
nn_activation_function = 'tanh_opt';
nn_momentum = .6;
nn_plot = 1;
nn_output = 'softmax';
nn_scaling_learning_rate = .99;
nn_weight_penalty_L2 = .1;
nn_non_sparsity_penalty = .1;
nn_sparsity_target = .05; % does nothing if above is set to 0
nn_input_zero_masked_fraction = 0; % only non-zero for autoencoders
nn_dropout_fraction = .5;

% train the dbn and nn
create_train_save_beatles_dbn_nn_model(...
    run, window_size, window_overlap, preprocessing_epsilon,...
    preprocessing_k, dbn_train_percentage, dbn_layer_sizes,...
    dbn_is_visible_layer_gaussian, dbn_num_epochs, dbn_song_batch_size,...
    dbn_mini_batch_size, dbn_momentum, dbn_binary_learning_rate,...
    dbn_gaussian_learning_rate, nn_train_percentage, nn_num_epochs,...
    nn_batch_size, nn_learning_rate, nn_activation_function, nn_momentum,...
    nn_plot, nn_output, nn_scaling_learning_rate, nn_weight_penalty_L2,...
    nn_non_sparsity_penalty, nn_sparsity_target,...
    nn_input_zero_masked_fraction, nn_dropout_fraction)

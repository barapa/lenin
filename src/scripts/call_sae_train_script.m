% FIRST SECTION IS TRAINING THE DBN AND NN AND SAVING THE RESULTS. 
% SECOND SECTION IS WRITING THE ACTIVATIONS TO FILES FOR SVM TRAINING.

% set environment global vars
LENIN_DATA_DIR = 'var/data/lenin';
%global LENIN_DATA_DIR;

% TRAINING DBN AND NN

% data
run = 1; % we will just do run #1 to start, and do others on good models
window_size = 1024;
window_overlap = 512;
preprocessing_epsilon = .00001;
preprocessing_k = 300;
% sae
sae_train_percentage = 30; % 30, 60, or 90
sae_layer_sizes = [50 100];
sae_activation_function = 'sigm';
sae_num_epochs = 100;
sae_song_batch_size = 20;
sae_mini_batch_size = 25;
sae_learning_rate = 1;
sae_input_zero_masked_fraction = .5;
% nn
nn_train_percentage = 30; % 30, 60, or 90. 
nn_song_batch_size = 10;
nn_num_epochs = 100;
nn_batch_size = 25;
nn_learning_rate = .1;
nn_activation_function = 'sigm'; % 'tanh_opt' or 'sigm'
nn_momentum = .6;
nn_plot = 1;
nn_output = 'softmax';
nn_scaling_learning_rate = 1;
nn_weight_penalty_L2 = 0;
nn_non_sparsity_penalty = 0;
nn_sparsity_target = 0; % does nothing if above is set to 0
nn_input_zero_masked_fraction = 0; % only non-zero for autoencoders
nn_dropout_fraction = .1;

% train the dbn and nn
model_filename = create_train_save_beatles_dbn_nn_model(...
    run, window_size, window_overlap, preprocessing_epsilon,...
    preprocessing_k, dbn_train_percentage, dbn_layer_sizes,...
    dbn_is_visible_layer_gaussian, dbn_num_epochs, dbn_song_batch_size,...
    dbn_mini_batch_size, dbn_momentum, dbn_binary_learning_rate,...
    dbn_gaussian_learning_rate, nn_train_percentage, nn_num_epochs,...
    nn_batch_size, nn_learning_rate, nn_activation_function, nn_momentum,...
    nn_plot, nn_output, nn_scaling_learning_rate, nn_weight_penalty_L2,...
    nn_non_sparsity_penalty, nn_sparsity_target,...
    nn_input_zero_masked_fraction, nn_dropout_fraction, nn_song_batch_size);


% CREATE TRAINING AND TESTING DATA FOR SVM.
% if you didn't capture the model_filename like above, because you are
% doing the SVM part after you have trained other DBNs, just give this
% function the filename of the model, including the .mat, but do not
% include the path. 
%
% Look at layers param to this function to see how to select only certain
% layers from the NN

%layers = [2, 3, 4, 5];
convert_trained_dbn_to_svm_efficient(model_filename);




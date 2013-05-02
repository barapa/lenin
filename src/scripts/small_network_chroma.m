function [ ] = small_network_chroma(run)
% set environment global vars
LENIN_DATA_DIR = 'var/data/lenin';
global LENIN_DATA_DIR;
DONT_VISUALIZE = 1;
global DONT_VISUALIZE;

disp(sprintf('RUN %d ------------------------------------------------', run));

% TRAINING DBN AND NN ========================================================

% data -----------------------------------
% run = 1; % we will just do run #1 to start, and do others on good models

data_include_left = 4;
data_include_right = 4;

% dbn ------------------------------------
dbn_train_percentage = 90; % 30, 60, or 90
dbn_layer_sizes = [100 100 50];
dbn_is_visible_layer_gaussian = 1;
dbn_num_epochs = 100;
dbn_song_batch_size = 15;
dbn_mini_batch_size = 50;
dbn_momentum = 0.9;
dbn_binary_learning_rate = .001;
dbn_gaussian_learning_rate = .0001;
dbn_cdk = 5;
% nn
nn_train_percentage = 90; % 30, 60, or 90. 
nn_song_batch_size = 30;
nn_num_epochs = 100;
nn_batch_size = 25;
nn_learning_rate = .1;
nn_activation_function = 'sigm'; % 'tanh_opt' or 'sigm'
nn_momentum = .7;
nn_plot = 1;
nn_output = 'softmax';
nn_scaling_learning_rate = .9999;
nn_weight_penalty_L2 = 0;
nn_non_sparsity_penalty = 0.01;
nn_sparsity_target = 0.7; % does nothing if above is set to 0
nn_input_zero_masked_fraction = 0; % only non-zero for autoencoders
nn_dropout_fraction = 0;

% train the dbn and nn -------------------
[ model_filename, error_rate ] = ...
    create_train_save_chroma_beatles_dbn_nn_model(...
        run,...
        data_include_left,...
        data_include_right,...
        dbn_train_percentage,...
        dbn_layer_sizes,...
        dbn_is_visible_layer_gaussian,...
        dbn_num_epochs,...
        dbn_song_batch_size,...
        dbn_mini_batch_size,...
        dbn_momentum,...
        dbn_binary_learning_rate,...
        dbn_gaussian_learning_rate,...
        dbn_cdk,...
        nn_train_percentage,...
        nn_num_epochs,...
        nn_batch_size,...
        nn_learning_rate,...
        nn_activation_function,...
        nn_momentum,...
        nn_plot,...
        nn_output,...
        nn_scaling_learning_rate,...
        nn_weight_penalty_L2,...
        nn_non_sparsity_penalty,...
        nn_sparsity_target,...
        nn_input_zero_masked_fraction,...
        nn_dropout_fraction,...
        nn_song_batch_size);


% CREATE TRAINING AND TESTING DATA FOR SVM.
% if you didn't capture the model_filename like above, because you are
% doing the SVM part after you have trained other DBNs, just give this
% function the filename of the model, including the .mat, but do not
% include the path. 
%
% Look at layers param to this function to see how to select only certain
% layers from the NN

left_frames = 2;
right_frames = 0;

layers = [2, 3, 4];
convert_trained_dbn_to_svm_efficient(...
    model_filename,...
    layers,...
    left_frames,...
    right_frames);

layers = [1];
convert_trained_dbn_to_svm_efficient(...
    model_filename,...
    layers,...
    left_frames,...
    right_frames);

layers = [1, 2, 3, 4];
convert_trained_dbn_to_svm_efficient(...
    model_filename,...
    layers,...
    left_frames,...
    right_frames);

disp(sprintf('nn_error_rate: %f', error_rate));



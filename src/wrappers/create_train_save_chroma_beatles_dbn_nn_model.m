function [ model_filename ] = create_train_save_chroma_beatles_dbn_nn_model(...
    run,...
    dbn_train_percentage,...
    dbn_layer_sizes,...
    dbn_is_visible_layer_gaussian,...
    dbn_num_epochs,...
    dbn_song_batch_size,...
    dbn_mini_batch_size,...
    dbn_momentum,...
    dbn_binary_learning_rate,...
    dbn_gaussian_learning_rate,...
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
    nn_song_batch_size)

[ dbn_train_song_filenames, test_song_filenames ] = load_run_data(...
    run, dbn_train_percentage) ;

[ nn_train_song_filenames, ~ ] = load_run_data(...
    run, nn_train_percentage) ;

[ dbn_train_song_filenames ] = append_chroma_paths(db_train_song_filenames) ;
[ test_song_filenames ] = append_chroma_paths(test_song_filenames) ;
[ nn_train_song_filenames ] = append_chroma_paths(nn_train_song_filenames) ;

% DBN SETUP AND TRAINING =====================================================
[ dbn_network_params ] = create_dbn_network_params(...
    dbn_layer_sizes, dbn_is_visible_layer_gaussian) ;

[ dbn_training_params ] = create_dbn_pre_training_params(...
    dbn_num_epochs,...
    dbn_song_batch_size,..
    dbn_mini_batch_size,..
    dbn_momentum,...
    dbn_gaussian_learning_rate,...
    dbn_binary_learning_rate) ;

[ dbn, ~ ] = pre_train_dbn(...
    dbn_network_params, dbn_training_params, dbn_train_song_filenames) ;

% NN SETUP AND TRAINING ======================================================

[ nn_training_params ] = create_nn_training_params(...
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
    nn_song_batch_size) ;

[ nn ] = train_nn_song_batches(...
    dbn, nn_training_params, nn_train_song_filenames, test_song_filenames) ;

disp('Loading testing data...') ;
[ test_nn_x, ~, test_nn_y ] = load_songs(test_song_filenames) ;
disp('...done');

[ error_rate, errors ] = nntest(nn, test_nn_x', test_nn_y') ;
disp(sprintf('Neural Network Softmax Error Rate: %s', num2str(error_rate))) ;

% TODO: refactor save_rbm_dbn so pre_processing is last param and remove it
% from the list here.
filename_of_model = save_rbm_dbn(...
    dbn,...
    dbn_training_params,...
    dbn_network_params,...
    preprocessing_params,...
    dbn_train_file_names,...
    nn_train_file_names,...
    test_file_names,...
    nn,...
    nn_training_params,...
    error_rate);




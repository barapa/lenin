function [] = create_train_SAE_model()

% Ensure stft data exists for given params
stft_beatles_songs(window_size, window_overlap);

% get song names for training and testing
[sae_train_song_names test_song_names] = load_run_data(run,...
  sae_train_percentage);
[nn_train_song_names ~] = load_run_data(run, nn_train_percentage);

% get full paths to the songs for this run and the stft params
sae_train_file_names = get_song_data_full_paths(sae_train_song_names,...
  window_size, window_overlap)
nn_train_file_names = get_song_data_full_paths(sae_train_song_names,...
  window_size, window_overlap)
test_file_names = get_song_data_full_paths(test_song_names,...
  window_size, window_overlap)

% set up whitening parameters (and stft params for the sake of saving)
preprocessing_params = create_dbn_pre_processing_params(...
    preprocessing_epsilon, preprocessing_k, window_size, window_overlap);

% ---- SAE SETUP AND TRAINING ----
% set up dbn network topology
sae_network_params = create_sae_network_params(sae_layer_sizes,...
  sae_activation_function );

% set up dbn training params
sae_training_params = create_sae_training_params(sae_learning_rate,...
  sae_input_zero_masked_function, sae_num_epochs, sae_mini_batch_size,...
  sae_song_batch_size);

% train sae, saving preprocessing params for later use
[sae, sae_sizes, preprocessing_params] = pre_train_sae(sae_train_file_names,...
  sae_network_params, sae_training_params, preprocessing_params);


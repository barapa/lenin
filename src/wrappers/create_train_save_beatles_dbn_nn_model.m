% run :           an integer between 1 and 10 that indicates which
%                 'run' to use. For example 3 will train assuming
%                 the test data from the 3rd run.
% window_size:    a scalar power to 2 specifying the window size to use for
%                 for the stft.
%                 E.g., 1024
% window_overlap: a scalar representing the overlap between windows for the
%                 stft.
%                 E.g., 512 
% preprocessing_epsilon:
%                 whitening parameter. .00001 is good.
% preprocessing_k:
%                 used for pca whitening. This will be the number of dimensions
%                 of the visible vectors                
% dbn_train_percentage: 
%                 Integer indicating the amount of training data to
%                 use to train the unsupervised dbn with. Must be 30, 60, or 90.
%                 Songs will be selected from the run specification.
% dbn_layer_sizes: 
%                 a 1xL vector of integers indicating the size of each hidden layer.
%                 Does not include the final output layer of the FFNN or the
%                 visible input layer.
%                 Ex. [1000, 500, 100]
% dbn_is_visible_layer_gaussian:
%                 1 to set the visible layer to be Gaussian, 0 otherwise.
% dbn_num_epochs: integer for number of training epochs for dbn
% dbn_song_batch_size:
%                 integer for number of songs in a batch
% dbn_mini_batch_size:
%                 integer specifying the traditional training batch size
%                 as described in the literature
% dbn_momentum:   dbn momentum for training.
% dbn_binary_learning_rate:
%                 dbn learning rate for binary neurons
% dbn_gaussian_learning_rate:
%                 dbn learning rate for gaussian neurons
% nn_train_percentage:
%                 30, 60, or 90. For now, 90 will be too big so do 30.
% nn_num_epochs:  integer number of training epochs
% nn_batch_size:  integer batch size of each training step
% nn_learning_rate: 
%                 learning rate. Typically needs to be lower when using 'sigm'
%                 activation function and non-normalized inputs
% nn_activation_function:
%                 activation functions of hidden layers. 'sigm' for sigmoid
%                 or 'tanh_opt' for optimal tanh.
% nn_momentum:    momentum
% nn_plot:        set to 1 if you want to plot the output of the training,
%                 0 otherwise
% nn_output:      final output unit. 'sigm', 'softmax' or 'linear'.
% nn_scaling_learning_rate
%               : Scaling factor for the learning rate (each epoch).
% nn_weight_penalty_L2
%               : L2 regularization on weights. 0 for no regularization.
% nn_non_sparsity_penalty
%               : Non-sparsity penalty. Penalty punishing non-sparsity.
% nn_sparsity_target
%               : Sparsity target (generally set to 0.05). Does nothing if
%                 if non_sparsity_penalty is set to zero.
% nn_input_zero_masked_fraction
%               : Used only for denoising autoencoders. Set to zero for DBNs.
% nn_dropout_fraction
%               : Randomly omits this fraction of feature detectors on each
%                 training case. Supposedly leads to better results and less
%                 over fitting. See Hinton paper:
%                 http://arxiv.org/abs/1207.0580
%
% filename_of_model
%               : returned value is the filename of the saved model, without the
%                 path. Example: 'rbm_dbn_20130417T123919.mat'
% nn_song_batch_size
%               : song batch size for training nn, for memory conservation

function [ filename_of_model ] = create_train_save_beatles_dbn_nn_model(...
    run, window_size, window_overlap, preprocessing_epsilon,...
    preprocessing_k, dbn_train_percentage, dbn_layer_sizes,...
    dbn_is_visible_layer_gaussian, dbn_num_epochs, dbn_song_batch_size,...
    dbn_mini_batch_size, dbn_momentum, dbn_binary_learning_rate,...
    dbn_gaussian_learning_rate, nn_train_percentage, nn_num_epochs,...
    nn_batch_size, nn_learning_rate, nn_activation_function, nn_momentum,...
    nn_plot, nn_output, nn_scaling_learning_rate, nn_weight_penalty_L2,...
    nn_non_sparsity_penalty, nn_sparsity_target,...
    nn_input_zero_masked_fraction, nn_dropout_fraction, nn_song_batch_size)

% Ensure stft data exists for given parameters. 
% Create if it is doesn't already exist.
stft_beatles_songs(window_size, window_overlap);

% get song names for training and testing dbn and nn for this run
[dbn_train_song_names, test_song_names] = load_run_data(run,...
    dbn_train_percentage);
[nn_train_song_names, ~] = load_run_data(run, nn_train_percentage);

% get full paths to the songs for this run and this stft params
dbn_train_file_names = get_song_data_full_paths(dbn_train_song_names,...
    window_size, window_overlap);
nn_train_file_names = get_song_data_full_paths(nn_train_song_names,...
    window_size, window_overlap);
test_file_names = get_song_data_full_paths(test_song_names,...
    window_size, window_overlap);

% set up whitening parameters (and stft params for the sake of saving)
preprocessing_params = create_dbn_pre_processing_params(...
    preprocessing_epsilon, preprocessing_k, window_size, window_overlap);

% ---- DBN SETUP AND TRAINING ----

% set up dbn network topology
dbn_network_params = create_dbn_network_params(dbn_layer_sizes,...
    dbn_is_visible_layer_gaussian);

% set up dbn training params
dbn_training_params = create_dbn_pre_training_params(dbn_num_epochs,...
    dbn_song_batch_size, dbn_mini_batch_size, dbn_momentum,...
    dbn_gaussian_learning_rate, dbn_binary_learning_rate);

% train dbn songs, save preprocessing params for later use
[dbn, preprocessing_params] = pre_train_dbn(dbn_network_params,...
    dbn_training_params, dbn_train_file_names, preprocessing_params);

% ---- FFNN SETUP AND TRAINING ----

% load data for training and testing. We will use same data for testing as
% for validation for now, since the only thing we do with the validation
% set is plot its results.

% setup ffnn parameters
nn_training_params = create_nn_training_params(...
    nn_num_epochs, nn_batch_size, nn_learning_rate, nn_activation_function,...
    nn_momentum, nn_plot, nn_output, nn_scaling_learning_rate,...
    nn_weight_penalty_L2, nn_non_sparsity_penalty, nn_sparsity_target,...
    nn_input_zero_masked_fraction, nn_dropout_fraction, nn_song_batch_size);

% train
nn = train_nn_song_batches( dbn, nn_training_params, nn_train_file_names,...
    preprocessing_params, test_file_names);
    
% calculate and print error
fprintf('%s\n', 'Loading testing data');
[test_nn_x, ~, test_nn_y] = load_songs(test_file_names);
fprintf('%s', 'Whitening testing data...');
test_nn_x = whiten_data(test_nn_x, preprocessing_params.X_avg,...
    preprocessing_params.W);
fprintf('done\n');

[error_rate, bad] = nntest(nn, test_nn_x', test_nn_y');
disp(['Error rate: ' num2str(error_rate)]);
    
filename_of_model = save_rbm_dbn(dbn, dbn_training_params, dbn_network_params,...
    preprocessing_params, dbn_train_file_names, nn_train_file_names,...
    test_file_names, nn, nn_training_params, error_rate, run,...
    nn_train_percentage, dbn_train_percentage);

end


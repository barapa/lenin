% run :           an integer between 1 and 10 that indicates which
%                 'run' to use. For example 3 will train assuming
%                 the test data from the 3rd run.
% data_include_left: how many left frames to append to the each frame.
% data_include_right: how many right frames to append to each frame.
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
% dbn_cdk:
%                 number of steps in the gibbs markoff chain run for the
%                 contrastive divergence algorithm.
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

function [ model_filename, error_rate ] = ...
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
        nn_song_batch_size)

[ dbn_train_song_filenames, ~, ~] =...
  load_run_data(run, dbn_train_percentage) ;

[ nn_train_song_filenames, test_song_filenames , validation_song_filenames] =...
  load_run_data(run, nn_train_percentage) ;

[ dbn_train_song_filenames ] = append_chroma_paths(dbn_train_song_filenames) ;
[ test_song_filenames ] = append_chroma_paths(test_song_filenames) ;
[ validation_song_filenames ] = append_chroma_paths(validation_song_filenames) ;
[ nn_train_song_filenames ] = append_chroma_paths(nn_train_song_filenames) ;

% DBN SETUP AND TRAINING =====================================================
[ dbn_network_params ] = create_dbn_network_params(...
    dbn_layer_sizes, dbn_is_visible_layer_gaussian) ;

[ dbn_training_params ] = create_dbn_pre_training_params(...
    dbn_num_epochs,...
    dbn_song_batch_size,...
    dbn_mini_batch_size,...
    dbn_momentum,...
    dbn_gaussian_learning_rate,...
    dbn_binary_learning_rate,...
    dbn_cdk) ;

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

preprocessing_params = {};
preprocessing_params.data_include_left = data_include_left;
preprocessing_params.data_include_right = data_include_right;

notes = 'chroma';
is_chroma = 1;
save_params = create_dbn_save_params(...
  dbn,...
  dbn_training_params,...
  dbn_network_params,...
  dbn_train_song_filenames,...
  nn_train_song_filenames,...
  validation_song_filenames,...
  test_song_filenames,...
  nn_training_params,...
  run,...
  nn_train_percentage,...
  dbn_train_percentage,...
  notes,...
  preprocessing_params,...
  dbn_cdk,...
  is_chroma);

[ nn ] = train_nn_song_batches(dbn, nn_training_params,...
    nn_train_song_filenames, validation_song_filenames, save_params,...
    preprocessing_params) ;

model_filename = save_params.model_filename;
[error_rate, ~] = compute_and_save_test_error_rate_on_saved_dbn_model(model_filename);
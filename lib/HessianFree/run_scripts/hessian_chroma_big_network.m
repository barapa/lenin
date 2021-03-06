function [] = hessian_chroma_big_network(run)
% some weird seeding stuff
seed = 1234;
randn('state', seed );
rand('twister', seed + 1 );

% Parameters for network and training
is_chroma = 1;
%run = 1;
dbn_train_percentage = 90;
maxepoch = 75;
numchunks = 4;
numchunks_test = 4;
runDesc = ['OFFICIAL RUN: chroma_big_network'];
layersizes = [800, 600, 50]; % do not include output or input layer

% choices: 'logistic', 'softmax', 'linear'
layertypes = {'logistic', 'logistic', 'logistic', 'softmax'}; % do not include input layer
                                                              % bud DO include output
                                                              % layer
errtype = 'class'; 
%report classification error (in addition to the quantity actually being
% optimized, i.e. the log-likelihood). Would change if tried an
% autoencoder.

weightcost = 2e-5; %standard L_2 weight-decay. Can set to 0.
initlambda = 5; % should be set so rho after first epoch is between .75 and .95

% These are for feeding the network, NOT for SVMs. For SVMs, you would
% have to do this first before adding more left and rights.
left_frames_network = 6;
right_frames_network = 2;

% Don't need to touch these                                                  
resumeFile = []; % set to resume from a previous model
paramsp = []; 
Win = [];
bin = [];
rms = 0; % 0 uses canonical error for output layer. Set to 1 to override to squared error
hybridmode = 1; % Just keep at 1
mattype = 'gn'; %Gauss-Newton.  
% The other choices probably won't work for whatever you're doing
    %mattype = 'hess';
    %mattype = 'empfish';
decay = 0.95; %
jacket = 0; % this is for GPU stuff, which we can't do


% set up the music data
[train_song_names, test_song_names, validation_song_names] =...
  load_run_data(run, dbn_train_percentage);

train_file_names = append_chroma_paths(train_song_names);
test_file_names = append_chroma_paths(test_song_names);
validation_file_names = append_chroma_paths(validation_song_names);

% load in all songs
% train_data is D x N
% one_hot_labels is L x N
[train_data, train_borders, train_one_hot_labels] = load_songs(train_file_names);
[validation_data, validation_borders, validation_one_hot_labels] =...
  load_songs(validation_file_names);
%[test_data, test_borders, test_one_hot_labels] = load_songs(test_file_names);

% standardize data
[train_data, standardize_params] = standardize(train_data);
validation_data = standardize(validation_data, standardize_params);
%test_data = standardize(test_data, standardize_params);

% append left and right frames
train_data = construct_features_with_left_and_right_frames(train_data,...
    left_frames_network, right_frames_network);
validation_data = construct_features_with_left_and_right_frames(...
  validation_data, left_frames_network, right_frames_network);
%test_data = construct_features_with_left_and_right_frames(test_data,...
%    left_frames_network, right_frames_network);

% get training and testing set to be the right number of frames so it
% doesnt break the algorithm wrt batch sizes
total_train_frames = size(train_data, 2);
total_train_frames = total_train_frames - mod(total_train_frames, numchunks);
train_frames_to_keep = randperm(total_train_frames); 

total_validation_frames = size(validation_data, 2);
total_validation_frames = total_validation_frames -...
  mod(total_validation_frames, numchunks_test);
validation_frames_to_keep = randperm(total_validation_frames); 

% take subset of data
train_data = train_data(:, train_frames_to_keep);
train_one_hot_labels = train_one_hot_labels(:, train_frames_to_keep);
validation_data = validation_data(:, validation_frames_to_keep);
validation_one_hot_labels = validation_one_hot_labels(:, validation_frames_to_keep);

% create object with additional info for saving the best model as we learn
save_params = create_save_params(...
  train_file_names,...
  validation_file_names,...
  test_file_names,...
  standardize_params,...
  run,...
  dbn_train_percentage,...
  left_frames_network,...
  right_frames_network,...
  is_chroma,...
  'NOTHING');

[paramsp layersizes, layertypes model_name] = ...
    hessian_free_train( runDesc, paramsp, Win, bin,...
    resumeFile, maxepoch, train_data, train_one_hot_labels,...
    numchunks, validation_data, validation_one_hot_labels, numchunks_test,...
    layersizes, layertypes, mattype, rms, errtype, hybridmode,...
    weightcost, decay, jacket, initlambda, save_params);

[train_err, validation_err, test_err] = get_class_error_rates(model_name)
save_error_rates(model_name, train_err, test_err, validation_err);

left_frames_svm = 2;
right_frames_svm = 0;

layers_for_svm = [2, 3, 4]
convert_trained_hf_net_to_svm(model_name, layers_for_svm, left_frames_svm,...
    right_frames_svm, 30);

layers_for_svm = [1]
convert_trained_hf_net_to_svm(model_name, layers_for_svm, left_frames_svm,...
    right_frames_svm, 30);

layers_for_svm = [1, 2, 3, 4]
convert_trained_hf_net_to_svm(model_name, layers_for_svm, left_frames_svm,...
    right_frames_svm, 30);

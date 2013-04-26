% function [ ] = convert_trained_hf_net_to_svm_chroma( model_name, layers,...
%     left_frames, right_frames)
% 
% Takes the filename of a model (not including path) and a vector 
% of which layers to use and writes the svm training and testing data files
%
% This function is much uglier now, in order to do this song by song so
% that it does not thrash.
%
% model_name: filename of a trained dbn model. 
%             example: rbm_dbn_20130417T123919.mat
% layers:     (optional) a vector of integers indicating which layers of the
%             network to use to create the features. If left out, all
%             layers are used be default.
% left_frames: the number of left frames to append to each feature vector
% right_frames: the number of right frames to append to each feature vector

function [ ] = convert_trained_hf_net_to_svm( model_name, layers,...
    left_frames, right_frames)

HF_MODEL_DIR = ['/var/data/lenin/hessian_free_models/' model_name '/final/'];

SVM_HMM_DATA_PATH = '/var/data/lenin/svm_hmm_data/';

svm_train_model_dir = strcat(SVM_HMM_DATA_PATH, model_name, '.mat', '/train/');
svm_test_model_dir = strcat(SVM_HMM_DATA_PATH, model_name, '.mat', '/test/');

ensure_dir_exists(SVM_HMM_DATA_PATH);
ensure_dir_exists(svm_train_model_dir);
ensure_dir_exists(svm_test_model_dir);

% load in model
model = load_trained_model(strcat(HF_MODEL_DIR, model_name, '.mat'));

% set layers to all if its not specified
if nargin < 2
    layers = 1:numel(model.layersizes);
end

% set frames to 0 if not specified
if nargin < 3
    left_frames = 0;
end
if nargin < 4
    right_frames = 0;
end

% 

% we need to do this song by song, for both the training and the testing set,
% otherwise we quickly run out of memory

% TRAINING
% do each song individually so we don't thrash
train_song_names = model.train_song_names;
disp('Computing SVM data for training songs...');
for i = 1 : numel(train_song_names) 
    disp(['Computing SVM data for training song #' num2str(i)]);
    disp('...loading song');
    [song_x, ~, song_y] = load_songs(train_song_names(i)); % load it in
    song_labels = one_hot_to_flat_labels(song_y);
    
    % standardize data
    song_x = standardize(song_x, model.standardize_params);
    % add left and right frames for the NETWORK, not the svm, as defined in
    % the modek
    song_x = construct_features_with_left_and_right_frames(song_x,...
    model.left_frames_network, model.right_frames_network);
    
    disp('...computing activations');
    
    [activations, ~] = get_hessian_activations(model.paramsp,...
        song_x, model.layersizes, model.layertypes);
    
    song_features = horzcat(activations{layers})';
    
    % add left and right frames as specified
    song_features = construct_features_with_left_and_right_frames(...
        song_features, left_frames, right_frames);
    
    disp('...writing features to svm_hmm data file');
    create_svm_data_files(svm_train_model_dir, {song_features}, {song_labels},...
        train_song_names(i), i, [layers_to_str(layers) '_',...
        left_right_frames_to_string(left_frames, right_frames)]);
end
disp('Completed computing SVM data for training songs...');


% TESTING
% do each song individually so we don't thrash
test_song_names = model.test_song_names;
disp('Computing SVM data for testing songs...');
for i = 1 : numel(test_song_names) 
    disp(['Computing SVM data for testing song #' num2str(i)]);
    disp('...loading song');
    [song_x, ~, song_y] = load_songs(test_song_names(i)); % load it in
    song_labels = one_hot_to_flat_labels(song_y);
    
    % standardize data
    song_x = standardize(song_x, model.standardize_params);
    % add left and right frames for the NETWORK, not the svm, as defined in
    % the modek
    song_x = construct_features_with_left_and_right_frames(song_x,...
    model.left_frames_network, model.right_frames_network);
    
    disp('...computing activations');
    
    [activations, ~] = get_hessian_activations(model.paramsp,...
        song_x, model.layersizes, model.layertypes);
    
    song_features = horzcat(activations{layers})';
    
    % add left and right frames as specified for SVM
    song_features = construct_features_with_left_and_right_frames(...
        song_features, left_frames, right_frames);
    
    disp('...writing features to svm_hmm data file');
    create_svm_data_files(svm_test_model_dir, {song_features}, {song_labels},...
        test_song_names(i), i, [layers_to_str(layers) '_',...
        left_right_frames_to_string(left_frames, right_frames)]);
end
disp('Completed computing SVM data for training songs...');

end


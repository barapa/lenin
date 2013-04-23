% function [ ] = convert_trained_sae_to_svm_efficient( model_name,...
%     layers)
% 
% Takes the filename of a model (not including path) and a vector 
% of which layers to use and writes the svm training and testing data files
%
% This function is much uglier now, in order to do this song by song so
% that it does not thrash.
%
% model_name: filename of a trained sae model. 
%             example: sae_20130417T123919.mat
% layers:     (optional) a vector of integers indicating which layers of the
%             network to use to create the features. If left out, all
%             layers are used be default.

function [ ] = convert_trained_sae_to_svm_efficient( model_name, layers)

SAE_MODEL_PATH = '/var/data/lenin/sae_models/';
SVM_HMM_DATA_PATH = '/var/data/lenin/svm_hmm_data/';

svm_train_model_dir = strcat(SVM_HMM_DATA_PATH, model_name, '/train/');
svm_test_model_dir = strcat(SVM_HMM_DATA_PATH, model_name, '/test/');

ensure_dir_exists(SVM_HMM_DATA_PATH);
ensure_dir_exists(svm_train_model_dir);
ensure_dir_exists(svm_test_model_dir);

% load in model
model = load_trained_model(strcat(SAE_MODEL_PATH, model_name));

% set layers to all if its not specified
if nargin == 1
    layers = 1 : model.nn.n;
end

% we need to do this song by song, for both the training and the testing set,
% otherwise we quickly run out of memory

% TRAINING
% do each song individually so we don't thrash
train_song_names = model.train_nn_songs;
disp('Computing SVM data for training songs...');
for i = 1 : numel(train_song_names) 
    disp(['Computing SVM data for training song #' num2str(i)]);
    disp('...loading song');
    [song_x, ~, song_y] = load_songs(train_song_names(i)); % load it in
    song_labels = one_hot_to_flat_labels(song_y);
    if isfield(model, 'preprocessing_params')
      disp('...whitening data');
      song_x = whiten_data(song_x, model.preprocessing_params.X_avg,...
          model.preprocessing_params.W);
    end
    disp('...computing activations');
    [~, nn] = nnpredict(model.nn, song_x');
    song_features = horzcat(nn.a{layers})';
    disp('...writing features to svm_hmm data file');
    create_svm_data_files(svm_train_model_dir, {song_features}, {song_labels},...
        train_song_names(i), i, layers_to_str(layers));
end
disp('Completed computing SVM data for training songs...');


% TESTING
% do each song individually so we don't thrash
test_song_names = model.test_nn_songs;
disp('Computing SVM data for testing songs...');
for i = 1 : numel(test_song_names) 
    disp(['Computing SVM data for testing song #' num2str(i)]);
    disp('...loading song');
    [song_x, ~, song_y] = load_songs(test_song_names(i)); % load it in
    song_labels = one_hot_to_flat_labels(song_y);
    if isfield(model, 'preprocessing_params')
      disp('...whitening data');
      song_x = whiten_data(song_x, model.preprocessing_params.X_avg,...
          model.preprocessing_params.W);
    end
    disp('...computing activations');
    [~, nn] = nnpredict(model.nn, song_x');
    song_features = horzcat(nn.a{layers})';
    disp('...writing features to svm_hmm data file');
    create_svm_data_files(svm_test_model_dir, {song_features}, {song_labels},...
        test_song_names(i), i, layers_to_str(layers));
end
disp('Completed computing SVM data for training songs...');

end


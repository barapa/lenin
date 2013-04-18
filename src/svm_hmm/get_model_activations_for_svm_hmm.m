% function [ train_features, train_labels, train_song_names, test_features,...
%     test_labels, test_song_names] = get_model_activations_for_svm_hmm(...
%     model, layers )
% 
% model : a trained DBM model that was previously saved
% layers: (optional) a vector of integers indicating which layers of the network
%         to use to create the features. If left out, all layers are used be
%         default.
%         
% train_features: 1 x S cell array, where S is the number of songs in the
%                 training set. The i'th element of the cell array is a D x N_i
%                 vector of features, where N_i is the number of frames in
%                 the i'th song.
% train_labels:   1 x S cell array. The i'th element is a 1 x N_i vector
%                 containing the flat labels of each frame, numbered starting
%                 from zero.
% train_song_names: 1 x S cell array where each element is the full pathname
%                 of the corresponding song
% test_features:  see train_features, but for test songs
% test_labels:    see train_labels, but for test songs
% test_song_names: see train_song_names but for test songs

function [ train_features, train_labels, train_song_names, test_features,...
    test_labels, test_song_names] = get_model_activations_for_svm_hmm(...
    model, layers )

% no layers specified, use all of them
if nargin == 1
    layers = 1:model.nn.n;
end

% load song data
disp('Loading raw training song data');
[train_nn_x, train_song_borders, train_nn_y] = load_songs(model.train_nn_songs);
disp('Converting training labels to one hot');
train_labels = one_hot_to_flat_labels(train_nn_y);
disp('Whitening training data');
train_nn_x = whiten_data(train_nn_x, model.preprocessing_params.X_avg,...
    model.preprocessing_params.W);

disp('Loading raw testing song data');
[test_nn_x, test_song_borders, test_nn_y] = load_songs(model.test_nn_songs);
disp('Converting testing labels to one hot');
test_labels = one_hot_to_flat_labels(test_nn_y);
disp('Whitening testing data');
test_nn_x = whiten_data(test_nn_x, model.preprocessing_params.X_avg,...
    model.preprocessing_params.W);

% put data through network by calling predict and concat layers together
disp('Computing activations for training data');
[~, nn] = nnpredict(model.nn, train_nn_x');
clear train_nn_x;
train_features_cat = horzcat(nn.a{layers})';
[train_features, train_labels] = split_data_into_song_cells(...
    train_features_cat, train_labels, train_song_borders );

disp('Computing activations for testing data');
[~, nn] = nnpredict(model.nn, test_nn_x');
clear test_nn_x;
test_features_cat = horzcat(nn.a{layers})';
[test_features, test_labels] = split_data_into_song_cells(...
    test_features_cat, test_labels, test_song_borders );

% song names
train_song_names = model.train_nn_songs;
test_song_names = model.test_nn_songs;

end
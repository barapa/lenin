function run_shf_chroma

addpath('code');

run = 1;
train_percentage = 30; % 30, 60, 90

[train_song_names, test_song_names] = load_run_data(run, train_percentage);
train_file_names = append_chroma_paths(train_song_names);
test_file_names = append_chroma_paths(test_song_names);

% load in all the songs
[train_data, ~, train_one_hot_labels] = load_songs(train_file_names);
[test_data, ~, test_one_hot_labels] = load_songs(test_file_names);

% only keep 20,000 frames of training data and 10,000 testing data
total_train_frames = size(train_data, 2);
target_train_frames = min(20000, total_train_frames);
train_frames_to_keep = randperm(total_train_frames, target_train_frames); 

total_test_frames = size(test_data, 2);
target_test_frames = min(10000, total_test_frames);
test_frames_to_keep = randperm(total_test_frames, target_test_frames); 

% take subset of data
train_data = train_data(:, train_frames_to_keep);
train_one_hot_labels = train_one_hot_labels(:, train_frames_to_keep);
test_data = test_data(:, test_frames_to_keep);
test_one_hot_labels = test_one_hot_labels(:, test_frames_to_keep);

% everything is currently DxN or LxN, we need to flip this
train_data = train_data';
train_one_hot_labels = train_one_hot_labels';
test_data = test_data';
test_one_hot_labels = test_one_hot_labels';

% now everything is NxD
train_data = double(train_data);
test_data = double(test_data);

size(train_data)

% Scale and whiten data
[train_data, scale_params] = standard(train_data);
test_data = standard(test_data, scale_params);

% Set experiment params
type = 'classification';    % 'classification' or 'autoencoder'
maxepoch = 300;            % the total number of passes through the data
gradbatchsize = 1000;
batchsize = 100;
arch = [400, 200, 50 25]; % do not include input layer, but DO include output layer

% activations supports 'linear', 'logistic', 'ReLU', 'softmax'
activations = {'logistic', 'logistic', 'logistic', 'softmax'}; 

% objfun MUST be matching loss to the last activation. Possible combinations are:
% 'linear' - 'MSE', 'logistic' - 'cross-entropy' and 'softmax' - 'softmax-entropy'
objfun = 'softmax-entropy';
corruption = 0.2;     % Probability of corrupting an input feature
verbose = 1;          % The lower the number, the more often it gives you updates.


params = create_params_object( type, maxepoch, gradbatchsize,...
    batchsize, arch, activations, objfun, corruption, verbose);

[theta, results, params] = train_hf(train_data, train_one_hot_labels,...
    test_data, test_one_hot_labels, params);

save_shf_model(scale_params, theta, results, params, run, train_percentage,...
    train_file_names, test_file_names, notes);


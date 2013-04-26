function nnet_music

run = 1;
window_size = 2^12;
window_overlap = 2^11;
nfft = 2^10;
preprocessing_epsilon = .00001;
preprocessing_k = 2^10;
preprocessing_k = min(preprocessing_k, nfft / 2 + 1);
dbn_train_percentage = 30;

stft_beatles_songs(window_size, window_overlap, nfft);
[train_song_names, test_song_names] = load_run_data(run,...
  dbn_train_percentage);

train_file_names = get_song_data_full_paths(...
  train_song_names, window_size, window_overlap, nfft);
test_file_names = get_song_data_full_paths(...
  test_song_names, window_size, window_overlap, nfft);

preprocessing_params = create_dbn_pre_processing_params(...
  preprocessing_epsilon, preprocessing_k, window_size, window_overlap, nfft);

% load in all songs  and calculate whitening params
% train_data is D x N
% one_hot_labels is Labels x N
[train_data, train_borders, train_one_hot_labels, preprocessing_params] = ...
  load_songs(train_file_names, preprocessing_params);
[test_data, test_borders, test_one_hot_labels] = ...
 load_songs(test_file_names);


numchunks = 4
numchunks_test = 4;

% only keep 20,000 frames of training data and 10,000 testing data
total_train_frames = size(train_data, 2);
num_train_frames = min(500000, total_train_frames);
% ensure its dividisble by num batches
num_train_frames = num_train_frames - mod(num_train_frames, numchunks)
train_frames_to_keep = randperm(total_train_frames, num_train_frames); 

total_test_frames = size(test_data, 2);
num_test_frames = min(200000, total_test_frames);
% ensure its dividisble by num batches
num_test_frames = num_test_frames - mod(num_test_frames, numchunks_test)
test_frames_to_keep = randperm(total_test_frames, num_test_frames); 

% take subset of data
train_data = train_data(:, train_frames_to_keep);
train_one_hot_labels = train_one_hot_labels(:, train_frames_to_keep);
test_data = test_data(:, test_frames_to_keep);
test_one_hot_labels = test_one_hot_labels(:, test_frames_to_keep);

% whiten the data
%train_data = whiten_data(train_data, preprocessing_params.X_avg,...
%  preprocessing_params.W);
%test_data = whiten_data(test_data, preprocessing_params.X_avg,...
%  preprocessing_params.W);

% data is D x N or L x N
% normalize the data so each vector sums to 1
train_data = bsxfun(@times, train_data, 1./(sum(train_data, 1)));
test_data = bsxfun(@times, test_data, 1./(sum(test_data, 1)));

seed = 1234;

randn('state', seed );
rand('twister', seed+1 );


%you will NEVER need more than a few hundred epochs unless you are doing
%something very wrong.  Here 'epoch' means parameter update, not 'pass over
%the training set'.
maxepoch = 500;


%CURVES
%%%%%%%%%%%%%%%%%
%this dataset (by Ruslan Salakhutdinov) is available here: http://www.cs.toronto.edu/~jmartens/digs3pts_1.mat

runName = 'HFtestrun_music_logistic_output_normalized';

runDesc = ['seed = ' num2str(seed) ', Normalized, unwhitened frames' ];

%next try using autodamp = 0 for rho computation.  both for version 6 and
%versions with rho and cg-backtrack computed on the training set

layersizes = [400, 200, 50];
layertypes = {'logistic', 'logistic', 'logistic', 'softmax'}
%layersizes = [400 200 100 50 25 6 25 50 100 200 400];
%Note that the code layer uses linear units
%layertypes = {'logistic', 'logistic', 'logistic', 'logistic', 'logistic',...
%              'linear', 'logistic', 'logistic', 'logistic', 'logistic',...
%              'logistic', 'logistic'};

resumeFile = [];

paramsp = [];
Win = [];
bin = [];
%[Win, bin] = loadPretrainedNet_curves;

mattype = 'gn'; %Gauss-Newton.  The other choices probably won't work for whatever you're doing
%mattype = 'hess';
%mattype = 'empfish';

rms = 0;

hybridmode = 1;

%decay = 1.0;
decay = 0.95;

jacket = 0;
%this enables Jacket mode for the GPU
%jacket = 1;

errtype = 'class'; %report the L2-norm error (in addition to the quantity actually being optimized, i.e. the log-likelihood)

%standard L_2 weight-decay:
weightcost = 2e-5
%weightcost = 0


nnet_train_2( runName, runDesc, paramsp, Win, bin, resumeFile, maxepoch, train_data, train_one_hot_labels, numchunks, test_data, test_one_hot_labels, numchunks_test, layersizes, layertypes, mattype, rms, errtype, hybridmode, weightcost, decay, jacket);

% function [ dbn, opt_preprocessing_params ] = pre_train_dbn(...
%     network_params, training_params, files_to_train, opt_preprocessing_params )
%
% Pretrain a deep belief network and return the pre-trained network.
%
% Inputs:
%   network_params : Object containing all of the DBN network parameters.
%
%     - network_params.layer_sizes :
%          a 1 x n vector of scalars where each scalar value is the number of
%          nodes in that hidden layer. The size of the visible layer is NOT
%          specified
%
%     - network_params.gaussian_visible_units:
%          a 1 indicating the lowest RBM containing the visible inputs should
%          be a Gaussian-Bernoulli RBM. 0 indicates it is Bernoulli-Bernoulli.
%
%   training_params : Object containing the training parameters for the
%                    pre-training phase.
%
%     - training_params.num_epochs:
%         A scalar. The number of training epochs to perform on each RBM
%         training
%
%     - training_params.song_batch_size:
%         A scalar. The number of songs to concatenate into one and train the
%         DBN on at a time. This is at a higher level than epochs and
%         minibatches.
%
%     - training_params.mini_batch_size:
%         A scalar. The number of frames to use when training an RBM layer.
%         This is the normal meaning of the batchsize parameter, as described
%         in the literature
%
%     - training_params.momentum:
%         A scalar value between 0 and 1. The momentum used in training the
%         DBN for updating the weights.
%
%     - training_params.learning_rate:
%         A small scalar value, e.g., 0.05. The learning rate.
%
%   files_to_train : A cell array, where each element is a string containing
%                    the full pathname of a song matlab variable. The loaded
%                    object file has the following structure:
%
%                       samples: [d x n double]
%                         freqs: [d x 1 double]
%                    timestamps: [1 x n double]
%                      filename: '17-Julia.mp3'
%                        labels: [1 x n double]
%
%   opt_preprocessing_params : Optional object containing the preprocessing
%                              parameters for the data.
%
%     - opt_preprocessing_params.epsilon :
%         A scalar. The regularization term used using PCA whitening.
%
%     - opt_preprocessing_params.k :
%         A scalar (integer). The number of dimensions to project the data
%         onto.  If unspecified no dimensionality reduction is done.
%
% Ouputs:
%   dbn : A DBN object, as used by the framework, already pretrained.
%
function [ dbn, opt_preprocessing_params ] = pre_train_dbn(...
    network_params, training_params, files_to_train, opt_preprocessing_params )
fprintf('%s\n', 'Setting up DBN.');

% setup network parameters
dbn.sizes = network_params.layer_sizes;
dbn.gaussian_visible_units = network_params.gaussian_visible_units;

% setup training parameters
opts.numepochs = training_params.num_epochs;
opts.batchsize = training_params.mini_batch_size;
opts.momentum = training_params.momentum;
opts.alpha = training_params.learning_rate;

% load in all songs to calculate preprocessing_params, don't save songs
[ ~, ~, ~, opt_preprocessing_params ] = load_songs( files_to_train,...
    opt_preprocessing_params);

% get the first song
[ song_data, ~, ~ ] = load_songs(files_to_train(1)) ;

song_data = song_data' ; % convert from d x n to n x d matrix.

% setup dbn
dbn = dbnsetup(dbn, song_data, opts);

% set up the song batch loop
num_songs = numel(files_to_train);
rand_song_order = randperm(num_songs);
num_song_batches = ceil(num_songs / training_params.song_batch_size);

fprintf('%s\n', 'Beginning DBN training.');

for b = 1 : num_song_batches
    fprintf('training song batch #%i of %i\n', b, num_song_batches);

    first_ind = (b - 1) * training_params.song_batch_size + 1;
    last_ind = min(b * training_params.song_batch_size, num_songs);


    fprintf('loading songs\n') ;
    [ train_x, ~, ~ ] = load_songs(...
        files_to_train(rand_song_order(:, first_ind:last_ind))) ;
    
    fprintf('whitening songs\n') ;
    train_x = whiten_data(train_x, opt_preprocessing_params.X_avg,...
          opt_preprocessing_params.W);

    train_x = train_x'; % convert from d x n to n x d matrix.

    fprintf('training network\n');
    % train dbn on the current batch of song data
    dbn = dbntrain(dbn, train_x, opts);

end

end


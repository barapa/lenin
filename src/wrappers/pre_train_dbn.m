function [ dbn ] = pre_train_dbn( network_params, training_params,...
    files_to_train )
%
% function [ dbn ] = pre_train_dbn( network_params, training_params,...
%    files_to_train )
%
% pre_train_dbn pretrains a deep belief network and returns the pretrained
% network.
%
% network_params: Object containing all of the DBN network parameters.'
%
%   network_params.layer_sizes: 
%       a 1 x n vector of scalars where each scalar value is the number of
%       nodes in that hidden layer. The size of the visible layer is NOT
%       specified
%
%
% training_params: Object containing the training parameters for the
%                  pre-training phase
%
%   training_params.num_epochs:
%       A scalar. The number of training epochs to perform on each RBM
%       training
%   training_params.song_batch_size:
%       A scalar. The number of songs to concatenate into one and train the
%       DBN on at a time. This is at a higher level than epochs and 
%       minibatches.
%   training_params.mini_batch_size:
%       A scalar. The number of frames to use when training an RBM layer.
%       This is the normal meaning of the batchsize parameter, as described
%       in the literature
%   training_params.momentum:
%       A scalar value between 0 and 1. The momentum used in training the
%       DBN for updating the weights.
%   training_params.learning_rate:
%       A small scalar value, e.g., 0.05. The learning rate.
%
%
% files_to_train: A cell array, where each element is a string containing
%                 the full pathname of a song matlab variable. The loaded
%                 object file has the following structure:
%                       samples: [d x n double]
%                         freqs: [d x 1 double]
%                    timestamps: [1 x n double]
%                      filename: '17-Julia.mp3'
%                        labels: [1 x n double]
%
% dbn: A DBN object, as used by the framework, already pretrained.

fprintf('%s\n', 'Setting up DBN.');

% setup network parameters
dbn.sizes = network_params.layer_sizes;

% setup training parameters
opts.numepochs = training_params.num_epochs;
opts.batchsize = training_params.mini_batch_size;
opts.momentum = training_params.momentum;
opts.alpha = training_params.learning_rate;

% load in first song, just to setup dbn with. Needs to be n x d.
song = load(files_to_train{1});
song_data = song.song.samples'; % convert to nxd matrix

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
    
    % load in each song in batch
    song_data = {};
    for s = first_ind : last_ind
        song = load(files_to_train{rand_song_order(s)});
        song_data{end+1} = song.song.samples'; % convert to n x d
    end
    
    % put all songs in this batch into one data matrix
    train_x = vertcat(song_data{:});
    
    % train dbn on the current batch of song data
    dbn = dbntrain(dbn, train_x, opts);
    
end

end


% function [ nn ] = train_nn_song_batches( dbn, training_params,...
%     files_to_train, preprocessing_params, files_to_validate)
%
% Wrapper for training a feed-forward neural network using a pre-trained
% deep belief network.
%
% dbn :       a pretrained deep belief net
% training_params :
%                an object containing the training parameters. Created using
%                the utility function create_nn_params(). See
%                create_nn_training_params() for more info.
% files_to_train : A cell array, where each element is a string containing
%                  the full pathname of a song matlab variable. The loaded
%                  object file has the following structure:
%
%                       samples: [d x n double]
%                         freqs: [d x 1 double]
%                    timestamps: [1 x n double]
%                      filename: '17-Julia.mp3'
%                        labels: [1 x n double]
% preprocessing_params: Params used for whitening.
% files_to_validate: A cell arary, where each element is a string
%                    containing the full pathname of a song matlab
%                    variable. Structure of matlab var defined above.
%
function [ nn ] = train_nn_song_batches( dbn, training_params,...
    files_to_train, preprocessing_params, files_to_validate)

% get the first song labels to set up the NN with the right number of
% labels
[ ~, ~, song_y ] = load_songs(files_to_train(1)) ;

[L, ~] = size(song_y);

% set number of outputs for last layer
nn = dbnunfoldtonn(dbn, L);

% set the opts params object
opts.numepochs = training_params.num_epochs;
opts.batchsize = training_params.batch_size;
if training_params.plot == 1
    opts.plot = 1;
end

% set all the parameters inside the nn
nn.activation_function = training_params.activation_function;
nn.learningRate = training_params.learning_rate;
nn.momentum = training_params.momentum;
nn.scaling_learningRate = training_params.scaling_learning_rate;
nn.weightPenaltyL2 = training_params.weight_penalty_L2;
nn.nonSparsityPenalty = training_params.non_sparsity_penalty;
nn.sparsityTarget = training_params.sparsity_target;
nn.inputZeroMaskedFraction = training_params.input_zero_masked_fraction;
nn.output = training_params.output;
nn.dropoutFraction = training_params.dropout_fraction;

% Calculate song batches
num_songs = numel(files_to_train);
rand_song_order = randperm(num_songs);
num_song_batches = ceil(num_songs / training_params.song_batch_size);

% if validation set passed in, load it and whiten it
if nargin == 5
    fprintf('%s\n', 'Loading validation data');
    [validation_x, ~, validation_y] = load_songs(files_to_validate);
    fprintf('%s\n', 'Whitening validation data');
    validation_x = whiten_data(validation_x, preprocessing_params.X_avg,...
        preprocessing_params.W);
    fprintf('done\n');
end

fprintf('%s\n', 'Beginning NN training.');

for b = 1 : num_song_batches
    first_ind = (b - 1) * training_params.song_batch_size + 1;
    last_ind = min(b * training_params.song_batch_size, num_songs);
    
    fprintf(['loading song batch #' num2str(b) '\n']) ;
    [ train_x, ~, train_y ] = load_songs(...
        files_to_train(rand_song_order(:, first_ind:last_ind))) ; 
    
    fprintf('whitening song batch\n') ;
    train_x = whiten_data(train_x, preprocessing_params.X_avg,...
          preprocessing_params.W);
      
    fprintf('training NN on song batch...') ;
    if nargin == 5
        nn = nntrain(nn, train_x', train_y', opts, validation_x',...
            validation_y'); % transpose inputs
    elseif nargin == 4
        nn = nntrain(nn, train_x', train_y', opts); % transpose inputs
    else
        error('Wrong number of arguments to train_nn');
    end
    fprintf('done\n') ;
end 
end


%function [ nn ] = train_nn( dbn, train_x, train_y, training_params,...
%    validation_x, validation_y)
%
% Wrapper for training a feed-forward neural network using a pre-trained
% deep belief network.
%
% dbn :       a pretrained deep belief net
% train_x :   a D x N matrix of training data
% train_y :   a L x N matrix of training data, where L = # of labels
% training_params :
%                an object containing the training parameters. Created using
%                the utility function create_nn_params(). See
%                create_nn_training_params() for more info.
% validation_x : (optional)
%                a D x N matrix of validation data to see how the network is
%                performing
% validation_y : (optional)
%                a L x N matrix of validation data to see how the network is
%                performing

function [ nn ] = train_nn( dbn, train_x, train_y, training_params,...
    validation_x, validation_y)

[L, N] = size(train_y);

% set number of outputs for last layer
nn = dbnunfoldtonn(dbn, L);

% set the opts params object
opts.numepochs = training_params.num_epochs;
opts.batchsize = training_params.batch_size;

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

% train
if  nargin == 6
  nn = nntrain(nn, train_x', train_y', training_params, validation_x',...
    validation_y'); % transpose inputs
elseif nargin == 4
  nn = nntrain(nn, train_x', train_y', training_params); % transpose inputs
else
  error('Wrong number of arguments to train_nn');
end

end


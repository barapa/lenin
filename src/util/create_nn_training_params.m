% function [ training_params ] = create_nn_training_params( num_epochs, batch_size, plot )
% 
% Creates the training params object to be passed to the train_nn wrapper.
% 
% num_epochs    : integer number of training epochs
% batch_size    : integer batch size of each training step
% learning_rate : learning rate. Typically needs to be lower when using 'sigm'
%                 activation function and non-normalized inputs
% activation_function :
%                 activation functions of hidden layers. 'sigm' for sigmoid
%                 or 'tanh_opt' for optimal tanh.
% momentum      : momentum
% plot          : set to 1 if you want to plot the output of the training,
%                 0 otherwise
% output        : output unit. 'sigm', 'softmax' or 'linear'.
% scaling_learning_rate
%               : Scaling factor for the learning rate (each epoch).
% weight_penalty_L2
%               : L2 regularization on weights. 0 for no regularization.
% non_sparsity_penalty
%               : Non-sparsity penalty. Penalty punishing non-sparsity.
% sparsity_target
%               : Sparsity target (generally set to 0.05). Does nothing if
%                 if non_sparsity_penalty is set to zero.
% input_zero_masked_fraction
%               : Used only for denoising autoencoders. Set to zero for DBNs.
% dropout_fraction
%               : Randomly omits this fraction of feature detectors on each
%                 training case. Supposedly leads to better results and less
%                 over fitting. See Hinton paper:
%                 http://arxiv.org/abs/1207.0580
% song_batch_size
%               : Number of songs per training batch

function [ training_params ] = create_nn_training_params( num_epochs,...
  batch_size, learning_rate, activation_function, momentum, plot, output,...
  scaling_learning_rate, weight_penalty_L2, non_sparsity_penalty,...
  sparsity_target, input_zero_masked_fraction, dropout_fraction,...
  song_batch_size)

training_params.num_epochs = num_epochs;
training_params.batch_size = batch_size;
training_params.learning_rate = learning_rate;
training_params.activation_function = activation_function;
training_params.momentum = momentum;
training_params.output = output;
training_params.scaling_learning_rate = scaling_learning_rate;
training_params.weight_penalty_L2 = weight_penalty_L2;
training_params.non_sparsity_penalty = non_sparsity_penalty;
training_params.sparsity_target = sparsity_target;
training_params.input_zero_masked_fraction = input_zero_masked_fraction;
training_params.dropout_fraction = dropout_fraction;
training_params.song_batch_szie = song_batch_size;

if plot == 1
    training_params.plot = 1;
end

end


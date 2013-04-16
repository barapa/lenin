% function [ nn ] = train_nn( dbn, train_x, train_y, training_params,...
%    activation_function)
%
% Wrapper for training a feed-forward neural network using a pre-trained
% deep belief network and softmax logitistic regression as the classifier.
%
% dbn :       a pretrained deep belief net
% train_x :   a D x N matrix of training data
% train_y :   a L x N matrix of training data, where L = # of labels
% training_params :
%             an object containing the training parameters. Created using
%             the utility function create_nn_params().
%
%    training_params.numepochs: number of training epochs
%    training_params.batchsize: batch size for training
%    training_params.plot:      include only if you want to plot the
%                               results of training.
% activation_function :
%             the activation function to use in the network. Use 0 for
%             sigmoid, and 1 for tanh_opt.
% validation_x : (optional)
%                a D x N matrix of validation data to see how the network is
%                performing
% validation_y : (optional)
%                a L x N matrix of validation data to see how the network is
%                performing

function [ nn ] = train_nn( dbn, train_x, train_y, training_params,...
    activation_function, validation_x, validation_y)

[L, N] = size(train_y);

% set number of outputs for last layer
nn = dbnunfoldtonn(dbn, L);

% set activation function
if activation_function == 0
    nn.activation_function = 'sigm';
else
    nn.activation_function = 'tanh_opt';
end

% train
if  nargin == 7
  nn = nntrain(nn, train_x', train_y', training_params, validation_x',...
    validation_y'); % transpose inputs
elseif nargin == 5
  nn = nntrain(nn, train_x', train_y', training_params); % transpose inputs
else
  error('Wrong number of arguments');
end

end


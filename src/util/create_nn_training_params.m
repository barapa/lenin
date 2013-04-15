% function [ training_params ] = create_nn_training_params( num_epochs, batch_size, plot )
% 
% Creates the training params object to be passed to the train_nn wrapper.
% 
% num_epochs : integer number of training epochs
% batch_size : integer batch size
% plot :       set to 1 if you want to plot the output of the training, 0 otherwise

function [ training_params ] = create_nn_training_params( num_epochs,...
    batch_size, plot )

training_params.numepochs = num_epochs;
training_params.batchsize = batch_size;
if plot == 1
    training_params.plot = 1;
end

end


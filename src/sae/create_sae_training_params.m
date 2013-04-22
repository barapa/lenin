%function [ training_params ] = create_sae_training_params(...
%    num_epochs, song_batch_size, mini_batch_size, learning_rate,...
%    input_zero_masked_fraction)
% num_epochs: number of epochs to run for each song batch
% song_batch_size: num of songs to train at a time
% mini_batch_size: number of frames used for each gradient calculation
% learning_rate: 
% input_zero_masked_fraction: I belive this determines some amount of noise
%                             used for the denoising auto encoder. I think it
%                             is similar to dropout. 
%                             0.5 seems to be a standard setting.

function [ training_params ] = create_sae_training_params(...
    num_epochs, song_batch_size, mini_batch_size, learning_rate,...
    input_zero_masked_fraction)
training_params.num_epochs = num_epochs;
training_params.song_batch_size = song_batch_size;
training_params.mini_batch_size = mini_batch_size;
training_params.learning_rate;
training_params.input_zero_masked_fraction = input_zero_masked_fraction;
end


% function [ song_matrix, song_borders, one_hot_labels ] = load_songs(...
% song_files, opt_preprocessing_params)
%
% Generates a large D x N matrix on songs, with a corresponding border vector
% to indicate where a new song begins.
%
% Inputs:
%  song_files :     A cell array, where each element is a string containing
%                   the full pathname of a song matlab variable. The loaded
%                   object file has the following structure:
%                        samples: [d x n double]
%                          freqs: [d x 1 double]
%                     timestamps: [1 x n double]
%                       filename: '17-Julia.mp3'
%                         labels: [1 x n double]
%
%   opt_preprocessing_params : Optional object containing the preprocessing
%                              parameters for the data.
%
%     - opt_preprocessing_params.epsilon :
%         A scalar in range (0, 1]. The regularization term used using PCA
%         whitening.
%
%     - opt_preprocessing_params.k :
%         A scalar (integer). The number of dimensions to project the data
%         onto. Songs are transfromed from D x N vectors to K x N vectors.
%
% Outputs:
%   song_matrix :   a D x N matrix of songs, where N = n_1 + ... + n_s, where s
%                   is the number of songs specified in song_files, and n_i is
%                   the second dimension of the samples vector for song i.
%
%  song_borders :   a S x 1 cell array of integers, where S is the number of
%                   songs specified in song_files. The value S(i) corresponds
%                   to the first column in song_matrix that corresponds to song
%                   i.  (S(1) always = 1).
%
%  one_hot_labels : an L x N matrix of chord labels ysing a one-hot
%                   representation, where L is the number of possible
%                   labels. This is always set to 25.
%
function [ song_matrix, song_borders, one_hot_labels ] = ...
    load_songs(song_files, opt_preprocessing_params)
  song_data = {} ;
  label_data = {} ;
  song_borders = {} ;
  running_total = 1 ;

  for i = 1 : length(song_files)
    song = load(song_files{i}) ;
    samples = song.song.samples ; % D x N_i matrix

    if nargin == 2 
      samples = pca_whiten(samples, opt_preprocessing_params.epsilon, ...
          opt_preprocessing_params.k) ;
    end

    song_data{end + 1} = samples ;
    label_data{end + 1} = labels_to_one_hot(song.song.labels) ; % L X N_i matrix
    song_borders{end + 1} = running_total ;
    running_total = running_total + size(song.song.samples, 2) ;
  end

  song_matrix = horzcat(song_data{:}) ;
  one_hot_labels = horzcat(label_data{:}) ;

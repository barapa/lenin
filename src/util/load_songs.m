% function [ song_matrix ] = load_songs(song_files)
%
% Generates a large D x N matrix on songs, with a corresponding border vector
% to indicate where a new song begins.
%
% Inputs:
%  song_files :  A cell array, where each element is a string containing
%                the full pathname of a song matlab variable. The loaded
%                object file has the following structure:
%                       samples: [d x n double]
%                         freqs: [d x 1 double]
%                    timestamps: [1 x n double]
%                      filename: '17-Julia.mp3'
%                        labels: [1 x n double]
%
% Outputs:
%   song_matrix : a D x N matrix of songs, where N = n_1 + ... + n_s, where s
%                 is the number of songs specified in song_files, and n_i is
%                 the second dimension of the samples vector for song i.
%  song_borders : a S x 1 vector of integers, where S is the number of songs
%                 specified in song_files. The value S(i) corresponds to the
%                 first column in song_matrix that corresponds to song i.
%                 (S(1) always = 1).
%
function [ song_matrix, song_borders ] = load_songs(song_files) 

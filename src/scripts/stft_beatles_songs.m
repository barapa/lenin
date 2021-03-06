% function [ beatles_unlabeled ] = stft_beatles_songs(window_size, window_overlap)
% Preprocess the beatles data.
%
% window_size: a scalar power to 2 specifying the window size. 
%              E.g., 1024
% window_overlap: a scalar representing the overlap between windows.
%              E.g., 512
% nfft: a scalar representing the length of the stft vector
% For each song, creates a struct array that has the fields:
%
%       samples - the STFT (each column is a frame, each row a freq)
%       freqs - same cardinality as rows in samples, freq of each row in Hz
%       timestamps - same cardinality as cols in samples, time of each col in
%                    seconds.
%       filename - stub of filename for song.
%
% EXPECTATIONS:
%   - beatles songs to be in /var/data/lenin/beatles
%   - to be run from top-level
%
function [ beatles_unlabeled ] = stft_beatles_songs(window_size, window_overlap, nfft)
  TOP_DIR = '/var/data/lenin/beatles/mp3s-32k/' ;
  LABEL_DIR = '/var/data/lenin/beatles/chordlabs/' ;
  SAVE_DIR = '/var/data/lenin/beatles_preprocessed/' ;
  disp(sprintf('[stft_beatles_songs] Preprocessing beatles songs found in %s',...
      TOP_DIR)) ;
  disp(sprintf('[stft_beatles_songs] Looking in %s for labels', LABEL_DIR)) ;
  disp(sprintf('[stft_beatles_songs] Saving output in %s', SAVE_DIR)) ;

  listings = dir(TOP_DIR) ;

  for i = 1:length(listings)

    if ~listings(i).isdir
      continue ;
    end

    if strcmp(listings(i).name, '.') || strcmp(listings(i).name, '..')
      continue ;
    end

    dirname = listings(i).name ;

    data_dir = strcat(TOP_DIR, dirname) ;
    data_dir = strcat(data_dir, '/') ;
    label_dir = strcat(LABEL_DIR, dirname) ;
    label_dir = strcat(label_dir, '/') ;
    stft_on_dir(data_dir, SAVE_DIR, window_size, window_overlap, nfft, label_dir) ;

  end

  disp(sprintf('[stft_beatles_songs] ...done')) ;


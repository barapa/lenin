% Preprocess the beatles data.
% 
% EXPECTATIONS:
%   - beatles songs to be in /var/data/lenin/beatles
%   - data/matlab to exist
%   - to be run from top-level
function [ beatles_unlabeled ] = stft_beatles_songs
  TOP_DIR = '/var/data/lenin/beatles/mp3s-32k/' ;
  SAVE_DIR = 'data/matlab/' ;
  disp(sprintf('[stft_beatles_songs] Preprocessing beatles songs found in %s',...
      TOP_DIR)) ;

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
    stft_on_dir(data_dir, SAVE_DIR) ;

  end

  disp(sprintf('[stft_beatles_songs] ...done')) ;


% Preprocess the beatles data.
% 
% EXPECTATIONS:
%   - beatles songs to be in /var/data/lenin/beatles
%   - data/matlab to exist
%   - to be run from top-level
function [ beatles_unlabeled ] = stft_beatles_songs
  TOP_DIR = '/var/data/lenin/beatles/mp3s-32k/' ;
  disp(sprintf('[stft_beatles_songs] Preprocessing beatles songs found in %s',...
      TOP_DIR)) ;

  listings = dir(TOP_DIR) ;

  songs = [ ] ;

  for i = 1:length(listings)

    if ~listings(i).isdir
      continue ;
    end

    dirname = listings(i).name ;

    data_dir = strcat(TOP_DIR, dirname) ;
    data_dir = strcat(data_dir, '/') ;
    new_songs = stft_on_dir(data_dir) ;
    songs = [ songs ; new_songs ] ;

  end

  disp(sprintf('[stft_beatles_songs] Saving data to data/matlab/beatles_unlabeled.mat')) ;
  beatles_unlabeled = songs ;
  save('data/matlab/beatles_unlabeled.mat', 'beatles_unlabeled', '-v7.3') ;

  disp(sprintf('[stft_beatles_songs] ...done')) ;


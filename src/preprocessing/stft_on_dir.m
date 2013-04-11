% Preprocesses song data
%
% data_dir - Absolute path (string) to top-level data directory.
%
% outputs:
% songs - an array of structs, each struct has the following items:
%         samples = STFT vector, each column is a different hamming window.
%         timestamps = time vector, has the same number of rows as samples,
%                      corresponds to the time (in seconds) of the center frame
%                       of the hamming window in F.
%         freqs = Frequency vector (I believe in Hz).
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
%
function [ songs ] = stft_on_dir(data_dir, save_dir)
  disp(sprintf('[stft_on_dir] Performing stft on songs in dir %s...', ...
      data_dir)) ;

  listings = dir(data_dir) ;
  songs = [ ] ;


  for i=1:length(listings)

    if listings(i).isdir
      continue ;
    end

    if strcmp(listings(i).name, '.DS_Store')
      continue ;
    end

    filename = strcat(data_dir, listings(i).name) ;
    stft(filename, listings(i).name, save_dir) ;

  end

  disp(sprintf('[stft_on_dir] ...done')) ;

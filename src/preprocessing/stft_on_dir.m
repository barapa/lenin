% Preprocesses song data
%
% data_dir - Absolute path (string) to top-level data directory.
% save_dir - Absolute path (string) to directory to save STFTs in.
% opt_label_dir - Optional absolute path (string) to directory containing label
%             file.
%
% outputs:
% songs - an array of structs, each struct has the following items:
%         samples = STFT vector, each column is a different hamming window.
%         timestamps = time vector, has the same number of rows as samples,
%                      corresponds to the time (in seconds) of the center frame
%                       of the hamming window in F.
%         freqs = Frequency vector (I believe in Hz).
%         filename = String of filename from raw audio, used so we can keep
%                    track of what song is what.
%         (opt) labels = Vector of chord labels for each timestamp.
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
%
% EXPECTATIONS:
%       - data file in data_dir and label file in label_dir have same name,
%         file extension (audio extenion for data file, .lab for label file).
%
function [ songs ] = stft_on_dir(data_dir, save_dir, opt_label_dir)
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

    if nargin = 2
      stft(filename, listings(i).name, save_dir) ;
    elseif nargin = 3
      label_filename = strcat(label_dir, listings(i).name) ;
      stft(filename, listings(i).name, save_dir, label_filename) ;
    else
      disp(sprinft('[stft_on_dir] called in invalid number of params!')) ;
    end % if nargin = 2

  end % for i = 1 : length(listings)

  disp(sprintf('[stft_on_dir] ...done')) ;

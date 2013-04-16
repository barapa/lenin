% Perform an STFT on a particular song.
%
% filename - Absolute path (string) to raw audio file.
% pretty_name - String to save as filename in struct array.
% opt_save_dir - Optional absolute path (string) to save file. If specified,
%                output of this function ('song') is saved to save_dir with
%                the filename pretty_name.
% opt_label_filename - Optional absolute path (string) to label file. If
%                      specified, a 'labels' vector will be added to struct
%                      array. Has same cardinality as timestamps, and gives a
%                      chord label given the following key:
%       LABEL KEY:
%              0 - 11: C ... B major
%             12 - 23: C ... B minor
%                  24: NO CHORD
% window_size: a scalar power to 2 specifying the window size. 
%              E.g., 1024
% window_overlap: a scalar representing the overlap between windows.
%              E.g., 512
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
function [ song ] = stft(filename, pretty_name, window_size, window_overlap,...
    opt_save_dir, opt_label_filename)
  nfft_points = window_size;

  [ raw, sample_rate ] = audioread(filename) ;
  [ ffts, freqs, times ] = spectrogram(raw, window_size, window_overlap, ...
      nfft_points, sample_rate) ;

  song = {} ;
  song.samples = abs(ffts) ;
  song.freqs = freqs ;
  song.timestamps = times ;


  if nargin > 1
    song.filename = pretty_name ;
  end

  if nargin == 6
    song.labels = label_timestamps(song.timestamps, opt_label_filename) ;
  end

  if nargin > 4
    save_filename = regexprep(pretty_name, '.mp3', '') ;
    save_filename = strcat(save_filename, '.mat') ;
    if nargin == 5
      disp(sprintf('[stft] Saving STFT (and labels) output to %s', save_filename)) ;
    else
      disp(sprintf('[stft] Saving STFT output to %s', save_filename)) ;
    end
    save(strcat(opt_save_dir, save_filename), 'song') ;
  end




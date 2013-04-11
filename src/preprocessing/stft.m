% Perform an STFT on a particular song.
%
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
function [ song ] = stft(filename, pretty_name, save_dir)
  NFFT_POINTS = 1024;
  WINDOW_OVERLAP = 512;
  WINDOW_SIZE = 1024;

  [ raw, sample_rate ] = audioread(filename) ;
  [ ffts, freqs, times ] = spectrogram(raw, WINDOW_SIZE, WINDOW_OVERLAP, ...
      NFFT_POINTS, sample_rate) ;

  song = {} ;
  song.samples = abs(ffts) ;
  song.freqs = freqs ;
  song.timestamps = times ;

  if nargin > 1
    song.filename = pretty_name ;
  end

  if nargin > 2
    save_filename = strcat(pretty_name, '.mat') ;
    disp(sprintf('[stft] Saving STFT output to %s', save_filename)) ;
    save(strcat(save_dir, save_filename), 'song') ;
  end




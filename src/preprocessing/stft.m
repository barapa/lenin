% Perform an STFT on a particular song.
%
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
function [ S ] = stft(filename)
  NFFT_POINTS = 1024;
  WINDOW_OVERLAP = 512;
  WINDOW_SIZE = 1024;

  [ raw, sample_rate ] = audioread(filename) ;
  [ ffts, freqs, times ] = spectrogram(raw, WINDOW_SIZE, WINDOW_OVERLAP, ...
      NFFT_POINTS, sample_rate) ;

  S = {} ;
  S.samples = abs(ffts) ;
  S.freqs = freqs ;
  S.timestamps = times ;

% Preprocesses song data
%
% data_dir - Absolute path (string) to top-level data directory.
%
% outputs:
% S - a cell-array, each element has the following items:
%         F = STFT vector, each row is a different hamming window.
%         T = time vector, has the same number of rows as F, corresponds to the
%             time (in seconds) of the center frame of the hamming window in F.
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
%
[ S ] = function stft_and_label(data_dir)
  disp(sprintf('stft called...')) ;

  listings = struct2cell(dir(data_dir)) ;
  songs = {} ;

  for i=1:length(listings)




  end

  %  [ raw, sample_rate ] = audioread(songs(i)) ;
  %  [ ffts, freqs, times ] = spectrogram(raw, 1024, 512, 1024, sample_rate) ;

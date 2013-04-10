% stft - Perform Short-Time Fourier Transform on audio data.
%
%
%
function [signals ] = stft(data, window_size, overlap_ratio)
  signals = [ ] ;
  index = 0 ;
  hamming_window = hamming(window_size) ;
  [ window, has_next ] = ...
      get_next_window(data, window_size, overlap_ratio, index) ;

  while has_next
    index = index + 1 ;
    [ window, has_next ] = ...
      get_next_window(data, window_size, overlap_ratio, index) ;

    window_freq = fft(hamming_window .* window) ;
    signals = [ signals ; window_freq' ] ;
  end

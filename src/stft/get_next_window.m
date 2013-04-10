function [ window, has_next ] = get_next_window(song, window_size, ...
    overlap_ratio, index)

  has_next = 1 ;
  index = get_next_index(window_size, overlap_ratio, index) ;

  if index > length(song)
    disp(sprintf('ERR: next index is beyond the end of the song')) ;
    window = [ ] ;
    has_next = 0
  end

  if index + window_size > length(song)
    diff = window_size - (length(song) - index) - 1;
    padding = zeros(diff, 1) ;
    window = [ song(index : length(song), :) ; padding ] ;
    has_next = 0 ;
  else
    window = song(index : index + window_size - 1, : ) ;
  end

function [ index ] = get_next_index(window_size, overlap_ratio, index)
  index = ceil(index + (1 - overlap_ratio) * window_size) ;

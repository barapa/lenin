% Generates a label vector for a corresponding timestamp vector, given a
% labels file.
%
% label_filename - Absolute path (string) to label file.
% timestamps - a 1 x N vector of timestamps (doubles).
%
% RETURNS
%   labels - a 1 X N vector of labels (ints \in [0, 24]).
%
function [ labels ] = label_timestamps(timestamps, label_filename)
  SPLIT_PATTERN = '(?<start>\d+.\d+) (?<end>\d+.\d+) (?<chord>.*)$' ;
  file_d = fopen(label_filename) ;
  line = fgets(file_d) ;
  chord_to_label = get_chord_to_label_map() ;
  index = 1 ;
  labels = [ ] ;

  while line ~= -1

    match = regexp(line, SPLIT_PATTERN, 'names') ;
    chord = strtrim(match.chord) ;

    if isKey(chord_to_label, chord)
      new_chord = chord ;
    else
      new_chord = normalize_chord(chord) ;
    end

    new_label = chord_to_label(new_chord) ;

    while (index <= length(timestamps) && ...
        timestamps(:, index) < str2double(match.end))
      labels = [ labels, new_label ] ;
      index = index + 1 ;
    end

    line = fgets(file_d) ;
  end

  % label files sometimes don't bother to label sound at the end, we just
  % append 'N' for the silence.

  while(index <= length(timestamps))
    labels = [ labels, chord_to_label('N') ] ;
    index = index + 1 ;
  end

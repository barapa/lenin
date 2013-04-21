% Translates a given chord into a "normalized" verison.
%
% e.g., a chord like "B:min/9" -> "B:min"
% e.g., a chord line "B:sus4" -> B
%
% The chords that are outputted are valid chords into the chord_label_chord map.
%
function [ normalized ] = normalize_chord(chord)
  SPLIT_PATTERN = '(?<chord>\w+[#]?)' ;
  match = regexp(chord, SPLIT_PATTERN, 'names') ;
  normalized = match.chord ;

  if strfind(chord, 'min')
    normalized = strcat(normalized, ':min') ;
  end

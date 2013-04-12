% Translates a given key into a "normalized" verison.
%
% e.g., a key like "B:min/9" -> "B:min"
% e.g., a key line "B:sus4" -> B
%
% The keys that are outputted are valid keys into the chord_label_key map.
%
function [ normalized ] = normalize_key(key)
  SPLIT_PATTERN = '(?<key>\w+[#]?):' ;
  match = regexp(key, SPLIT_PATTERN, 'names') ;
  normalized = match.key ;

  if strfind(key, 'min')
    normalized = strcat(normalized, ':min') ;
  end

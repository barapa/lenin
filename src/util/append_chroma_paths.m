% function [ filenames ] = append_chroma_paths(filenames)
% Append the 'data/chroma_formatted/' string to each filename in filenames.
%
% filenames : cell array of the song names, as found in run files.
function [ filenames ] = append_chroma_paths(filenames)
  CHROMA_DIR = 'data/chroma_formatted/' ;

  for i = 1 : numel(filenames)
    filenames{i} = [ CHROMA_DIR, filenames{i} ] ;
  end

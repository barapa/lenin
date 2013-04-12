% Method to change music filename (as saved in song.filename) into a label
% filename. Currently assumes file is .mp3. This is a method just so we can
% later support .wav, etc.
%
%
function [ label_filename ] = convert_music_filename_to_label_filename(music_filename)
  label_filename = regexprep(music_filename, 'mp3', 'lab') ;

% function [ full_song_paths ] = get_song_data_full_paths(...
%     song_names, window_size, window_overlap )
% Takes the names of song data files, as well as window size and window
% overlap, and returns the full paths to the actual song data that was
% created using the window params as specified. This does not gaurantee
% that the files exist, but these are the paths that they would be found
% under if they did exist.
% 
% song_names : cell array of the song names, as found in the run files.
% window_size : window size. See stft code.
% window_overlap: window overlap. See stft code.
% nfft:
% 
% full_song_paths : cell array of the full pathnames to the songs. This
%                   can be used to load in the actual song data files.

function [ full_song_paths ] = get_song_data_full_paths(...
    song_names, window_size, window_overlap, nfft )
    full_song_paths = cell(size(song_names));
    data_dir = get_full_data_path_for_preprocessing_params(window_size, window_overlap, nfft);
    for i = 1 : numel(song_names)
        full_song_paths{i} = strcat(data_dir, song_names{i});
    end

end


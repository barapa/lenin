% function [ song ] = stft(filename, window_size, window_overlap, pretty_name,...
%     opt_save_dir, opt_label_filename)
%
% Perform an STFT on a particular song. If you are trying to save the file
% and it already exists, THIS FUNCTION WILL RETURN NULL so that it doesn't
% have to load it in.
%
% filename - Absolute path (string) to raw audio file.
% pretty_name - String to save as filename in struct array.
% opt_save_dir - Optional absolute path (string) to save file. If specified,
%                output of this function ('song') is saved to save_dir with
%                the filename pretty_name.
% opt_label_filename - Optional absolute path (string) to label file. If
%                      specified, a 'labels' vector will be added to struct
%                      array. Has same cardinality as timestamps, and gives a
%                      chord label given the following key:
%       LABEL KEY:
%              0 - 11: C ... B major
%             12 - 23: C ... B minor
%                  24: NO CHORD
% window_size: a scalar power to 2 specifying the window size.
%              E.g., 1024
% window_overlap: a scalar representing the overlap between windows.
%              E.g., 512
%
% DEPENDENCIES:
%  audioread package by Dan Ellis
function [ song ] = stft(filename, window_size, window_overlap, pretty_name,...
    opt_save_dir, opt_label_filename)

  % Construct filename and check if it already exists. If it does, read it
  % in and return it. If it doesn't, run it and save it.
  if nargin > 4
        % params_directory_name is of the form windowsize_windowOverlap
        % ex. 1024_512/
        params_directory_name = [num2str(window_size) '_' num2str(window_overlap) '/'];

        % remove .mp3 if its there and add .mat regardless
        save_filename = regexprep(pretty_name, '.mp3', '') ;
        save_filename = strcat(save_filename, '.mat') ;

        % put it all together now
        save_directory = strcat(opt_save_dir, params_directory_name);
        save_filename =  strcat(save_directory, save_filename);

        % if it already exists, load it and return it.
        if exist(save_filename, 'file') == 2
            disp(sprintf('[stft] STFT %s already exists. Loading it in.', save_filename));
            %s = load(save_filename);
            %song = s.song;
            return;
        end
  end

  % STFT does not already exist, so we must create it and save it.
  nfft_points = window_size;

  [ raw, sample_rate ] = audioread(filename) ;
  [ ffts, freqs, times ] = spectrogram(raw, window_size, window_overlap, ...
      nfft_points, sample_rate) ;

  song = {} ;
  song.samples = abs(ffts) ;
  song.freqs = freqs ;
  song.timestamps = times ;


  if nargin > 3
    song.filename = pretty_name ;
  end

  if nargin == 6
    song.labels = label_timestamps(song.timestamps, opt_label_filename) ;
  end

  if nargin > 4
    ensure_dir_exists(save_directory) ;
    save(save_filename, 'song') ;
  end
end




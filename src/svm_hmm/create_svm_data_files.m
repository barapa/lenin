% function [ ] = create_svm_data_files( outfile_dir, features, labels, song_names )
%
% Writes the data file and labels file to the given outfile_dir.
%
% outfile_dir:  The directory where the data.dat file and true_labels.dat
%               file will be save
% features:     A 1 x S cell array of the features of each song.
%               Each element of the cell array is a D x N matrix, where D
%               is the number of dimensions of the features used (12 for
%               normal chroma) and N is the number of frames in the song.
% labels:       A 1 x S cell array of the chord labels of each song.
%               Each element of the cell array is a N x 1 vector, where N
%               is the number of frames in the song. Each element in the
%               vector is a chord label, numbered starting at zero.
% song_names:   A 1 x S cell array where each cell is a string with the song name

% The format of the output file is:
%   -TAG qid:EXNUM FEATNUM:FEATVAL FEATNUM:FEATVAL ... #SONG_NAME
%   -TAG is the label value
%   -EXNUM is the example number, in this case the song number. It is the
%          index into the the features cell array that the song comes from
%   -SONG_NAME is the name of the song, and appears in the comment

function [ ] = create_svm_data_files( outfile_dir, features, labels, song_names )

num_songs = numel(features);
dim = size(features{1}, 1);

data_file_name = [outfile_dir 'data.dat'];
data_fid = fopen(data_file_name,'wt');

labels_file_name = [outfile_dir 'true_labels.dat'];
labels_fid = fopen(labels_file_name,'wt');


% for each song
for song = 1 : num_songs
    % for each frame in the song
    song_features = features{song};
    song_labels = labels{song};
    % song labels must start with 1...so add 1 to each
    song_labels = song_labels + 1;
    for frame = 1 : numel(song_labels)
      chord_label = sprintf('%d', song_labels(frame));
      song_label = sprintf(' qid:%d ', song);
      features_ind_vec = reshape([1:dim; song_features(:,frame)'],1,[]);
      features_str = sprintf('%d:%.9f ', features_ind_vec);
      output_str = [chord_label song_label features_str ' # ' song_names{song}];
      labels_str = strcat(sprintf('%d', song_labels(frame)));
      fprintf(data_fid, '%s\n', output_str);
      fprintf(labels_fid, '%s\n', labels_str);
    end
end

fclose(data_fid);
fclose(labels_fid);
end


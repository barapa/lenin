% function [ data_cell, labels_cell ] = split_data_into_song_cells(...
%     x_data, labels, song_borders )
% Splits data into cell arrays of the data for each song as defined by the
% song borders
% 
% x_data : D x N matrix where N is the number of frames in all of the songs
%          combined
% labels : 1 x N vector of song labels, numbered 0 : 25
% song_borders : 1 x S cell array where S is the number of songs and the ith
%                element is the index of the first frame of the ith song into
%                the data_x matrix's columns.

function [ data_cell, labels_cell ] = split_data_into_song_cells(...
    x_data, labels, song_borders )

[D, N] = size(x_data);
S = numel(song_borders);

data_cell = cell(1, S);
labels_cell = cell(1, S);

for i = 1 : S
    start_ind = song_borders{i};
    if i == S
        end_ind = N;
    else
        end_ind = song_borders{i+1} - 1;
    end
    
    data_cell{i} = x_data(:, start_ind : end_ind);
    labels_cell{i} = labels(:, start_ind : end_ind);
end

end


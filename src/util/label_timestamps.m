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

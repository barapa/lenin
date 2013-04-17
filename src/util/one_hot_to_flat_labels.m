% function [ flat_labels ] = one_hot_to_flat_labels( one_hot_labels )
% Converts a one hot matrix of chord labels to a flat vector of labels
% where the lowest label has a value of 0;
% 
% one_hot_labels: L x N vector of one_hot labels. Only one element in each
%                 row can be a one, all others are zero.
% flat_labels:    1 x N vector of labels, numbered 0 to L-1

function [ flat_labels ] = one_hot_to_flat_labels( one_hot_labels )

[flat_labels, ~] = find(one_hot_labels == 1);
flat_labels = flat_labels - 1;
flat_labels = flat_labels';

end


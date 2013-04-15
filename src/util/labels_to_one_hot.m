% function [ one_hot_labels ] = labels_to_one_hot( labels, total_labels )
% 
% Converts a vector of labels represented as scalars and converts it to a
% label matrix using a one-hot encoding.
% 
% labels:         A nx1 or 1xn vector, where each element is an integer in
%                 the range [0, total_labels-1].
%
% total_labels:   (Optional Parameter, default = 25)
%                 The total number of possible labels (even if the highest
%                 label is not used in this dataset. For chord labeling, it
%                 should be 25, and this is the default.
%
% one_hot_labels: A total_labels x n matrix, where each column has exactly
%                 one element set to one, and all others set to zero. The
%                 label of 0 maps to the first row in the one_hot_labels
%                 matrix being turned on.

function [ one_hot_labels ] = labels_to_one_hot( labels, total_labels )


n = numel(labels);
default_label_count = 25; % (12 minor) + (12 major) + (1 no-chord)

if nargin < 2
    total_labels = default_label_count;
end

if max(labels) > total_labels
    error('label found that is greater than the allowable label');
elseif min(labels) < 0
    error('label found that is less than the allowable label');
else
    one_hot_labels = zeros(total_labels, n);

    for i = 1 : n
        one_hot_labels(labels(i) + 1, i) = 1;
    end
end

end
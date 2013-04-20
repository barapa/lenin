% function [ layers_str ] = layers_to_str( layers )
% Converts a layers vector that indiciates which layers to include in the SVM
% feature activations to a string to be included in the data file name of the
% svm data file.
% 
% layers: a 1 x L vector that indicates which layers to include. 
%         ex. [2 3 4] would include the 2nd, 3rd, and 4th layer
%        
% layers_str: A string to use to indicate the layers selected in the filename
%             of an svm data file.
%             Ex. 'layers_[2_3_4]'

function [ layers_str ] = layers_to_str( layers )
layers_str = strrep(mat2str(layers), ' ', '_');
layers_str = ['layers_' layers_str];
end


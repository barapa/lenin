%function [ preprocessing_params ] = create_dbn_pre_processing_params(epsilon,...
%    k, window_size, window_overlap)
%
% Create the pre-processing parameter object for use with pre_train_dbn().
% Descriptions of the inputs are found in src/wrappers/pre_train_dbn.
%
function [ preprocessing_params ] = create_dbn_pre_processing_params(epsilon,...
    k, window_size, window_overlap)

  preprocessing_params.epsilon = epsilon ;
  preprocessing_params.k = k ;
  preprocessing_params.window_size = window_size;
  preprocessing_params.window_overlap = window_overlap;

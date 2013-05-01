%function [ preprocessing_params ] = create_dbn_pre_processing_params(epsilon,...
%    k, window_size, window_overlap)
%
% Create the pre-processing parameter object for use with pre_train_dbn().
% Descriptions of the inputs are found in src/wrappers/pre_train_dbn.
%
function [ preprocessing_params ] = create_dbn_pre_processing_params(epsilon,...
    k, window_size, window_overlap, nfft, data_include_left, data_include_right)

  preprocessing_params.epsilon = epsilon ;
  preprocessing_params.k = k ;
  preprocessing_params.window_size = window_size;
  preprocessing_params.window_overlap = window_overlap;
  preprocessing_params.nfft = nfft;
  preprocessing_params.data_include_left = data_include_left;
  preprocessing_params.data_include_right = data_include_right;

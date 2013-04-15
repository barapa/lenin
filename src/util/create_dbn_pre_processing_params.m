% function [ preprocessing_params ] = create_dbn_pre_processing_params(...
%     epsilon, k)
%
% Create the pre-processing parameter object for use with pre_train_dbn().
% Descriptions of the inputs are found in src/wrappers/pre_train_dbn.
%
function [ preprocessing_params ] = create_dbn_pre_processing_params(epsilon, k)

  preprocessing_params.epsilon = epsilon ;
  preprocessing_params.k = k ;

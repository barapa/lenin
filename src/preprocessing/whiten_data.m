% function [ X_whitened ] = whiten_data(X, X_avg, W)
%
% Performs PCA whitening on a dataset.
%
% Inputs:
%      X - a D x N matrix of data to be transformed.
%  X_avg - a D x 1 centroid vector to make X zero-mean for each feature
%          separately.
%      W - A K x D whitening matrix, used to perform the whitening of X.
%
% Outputs:
%   X_whitened : A K x N matrix corresponding to the whitened data.
%
% NOTE: To generate X_avg and W, use generate_whitening_params.
%
function [ X_whitened ] = whiten_data(X, X_avg, W)
  X = X - repmat(X_avg, 1, size(X, 2)) ;
  X_whitened = W * X ;

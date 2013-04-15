% function [ X_avg, W ] = generate_whitening_params( X )
%
% Generates the parameters needed to whiten a matrix X of examples.
%
% Inputs:
%   X : a D x N matrix of examples (one example per column).
%
%   preprocessing_params : Optional object containing the preprocessing
%                          parameters for the data.
%
%     - opt_preprocessing_params.epsilon :
%         A scalar. The regularization term used during PCA whitening.
%
%     - opt_preprocessing_params.k :
%         A scalar (integer). The number of dimensions to project the data
%         onto.  If unspecified no dimensionality reduction is done.
%
% Outputs:
%
%   X_avg : A D x 1 centroid vector of each feature in the dataset.
%       W : The whitening matrix.
%
% To whiten a dataset, do the following:
%
%  X = X - repmat(X_avg, 1, size(X, 2)) ;
%  X_whitened = W * X ;
%
function [ X_avg, W ] = generate_whitening_params( X, preprocessing_params)
  X_avg = mean(X, 2) ;
  X_hat = repmat(avg, 1, size(X, 2)) ;
  X = X - X_hat ;

  sigma = X * X' / size(X, 2) ;
  [ U, S, ~ ] = svd(sigma) ;

  epsilon = preprocessing_params.epsilon ;
  k = preprocessing_params.k ;
  W = diag( 1 ./ sqrt(diag(S(:, 1:k)) + epsilon)) * U(:, 1:k)' ;

% function [ X_tilde ] = pca_whiten( X, epsilon, opt_k )
%
% Perform PCA whitening on X.
%
% Inputs:
%       X : a D x N matrix of examples (one example per column).
%  epison : a scalar in (0, 1], used for regularization.
%   opt_k : an integer, specifying the number of dimensions to keep in the
%           transformed data. Default is D.
%
% Outputs:
%  X_tilde : A K x N matrix of transformed examples.
%
% Performs the following:
%
%  1 - transforms X into X_hat, where each dimension has zero-mean across the
%      examples in X.
%
%  2 - computes X_rot, where X_rot = U' * X_hat, where U is the eigenvector
%      matrix of Sigma, where Sigma = X_hat * X_hat' / N.
%
%  3 - computes X_tilde, where X_tilde = X_rot / \sqrt(S_{i,i} + epsilon). Where
%      S_{i,i} is the i'th largest eigenvalue of Sigma.
%
%  4 - if k is specified, only keeps the first k dimensions of X_tilde.
%
function [ X_tilde ] = pca_whiten( X, epsilon, opt_k )
  % compute average for each dimension individually:
  avg = mean(X, 2) ;
  % subtract average for each dimension from that dimension:
  X_hat = X - repmat(avg, 1, size(X, 2)) ;
  sigma = X_hat * X_hat' / size(X, 2) ;
  [ U, S, ~ ] = svd(sigma) ;
  if nargin == 3
    X_tilde = diag( 1 ./ sqrt(diag(S(:, 1:opt_k)))) * U(:, 1:opt_k)' * X_hat ;
  else
    X_tilde = diag( 1 ./ sqrt(diag(S) + epsilon)) * U' * X_hat ; 
  end

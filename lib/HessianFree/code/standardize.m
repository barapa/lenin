% function [X, scaleparams] = standardize(XC, scaleparams)
% XC: DxN vector of data
% scaleparams: optional, to either standardize using precalculated params or
%              if left out, will calculate these AND apply them to data
                 

function [X, scaleparams] = standardize(XC, scaleparams)
    
    XC = XC';
    if ~exist('scaleparams','var')
        scaleparams.epsilon = 0.01;
        scaleparams.mean = mean(XC);
        scaleparams.sd = sqrt(var(XC) + scaleparams.epsilon);
    end
    X = bsxfun(@rdivide, bsxfun(@minus, XC, scaleparams.mean), scaleparams.sd);
    X = X';
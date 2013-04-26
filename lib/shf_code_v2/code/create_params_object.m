% function [ params ] = create_params_object( type, maxepoch, gradbatchsize,...
%     batchsize, arch, activations, objfun, corruption, verbose)
% See examples for what are valid params for each

function [ params ] = create_params_object( type, maxepoch, gradbatchsize,...
    batchsize, arch, activations, objfun, corruption, verbose)

% ensure activations and object function are legal
switch activations{end}
    case 'ReLU' 
        error('Cannot have ReLU as output layer');
    case 'linear'
        if ~strcmp('MSE', objfun)
            error('linear output must use MSE objective function');
        end
    case 'logistic'
        if ~strcmp('cross-entropy', objfun)
            error('logistic output must use cross-entropy objective function');
        end
    case 'softmax'
        if ~strcmp('softmax-entropy', objfun)
            error('softmax output must use softmax-entropy objective function');
        end
    otherwise
        error('invalid output activation')
end
        

% Pack parameters
params.type = type;
params.maxepoch = maxepoch;
params.batchsize = batchsize;
params.gradbatchsize = gradbatchsize;
params.arch = arch;
params.objfun = objfun;
params.activations = activations;
params.corruption = corruption;   
params.verbose = verbose;

end


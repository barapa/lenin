% Parameter settings for stochastic Hessian-free

    % classification or autoencoder
    type = 'classification';

    % The number of epochs i.e. passes through the training data
    maxepoch = 500;

    % The sizes of the gradient and curvature mini-batches
    % The defaults work well, but consider changing if they don't make sense with your data
    % The gradient batch size should be divisible by the curvature batch size!
    % If your dataset is really small, you're probably better off just using SGD
    gradbatchsize = 1000;
    batchsize = 100;

    % The layersizes. 
    % For classification, the last number should be the number of classes
    % For an autoencoder, the last number should be the number of features
    % Only supports symmetric encoding / decoding for autoencoders
    arch = [200 200 10];

    % activations supports 'linear', 'logistic', 'ReLU', 'softmax'
    % objfun MUST be matching loss to the last activation. Possible combinations are:
    % 'linear' - 'MSE', 'logistic' - 'cross-entropy' and 'softmax' - 'softmax-entropy'
    activations = {'ReLU', 'ReLU', 'softmax'};
    objfun = 'softmax-entropy';

    % Probability of corrupting an input feature
    corruption = 0.2;
    
    % Print results after this many epochs
    verbose = 5;

%--------------------------------------------------------------------------

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

    

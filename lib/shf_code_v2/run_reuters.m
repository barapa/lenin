% Experiment on Reuters dataset
addpath('data'); addpath('code');
load Reuters21578;

% Preprocess data
train = fea(trainIdx, :);
test = fea(testIdx, :);
train_L = gnd(trainIdx);
test_L = gnd(testIdx);
train_labels = full(sparse(train_L, 1:length(train_L), 1))';
test_labels = full(sparse(test_L, 1:length(test_L), 1))';

% Scale word counts
train = log(1 + train);
test = log(1 + test);

%------------------------------------------------------------------------------------------

% Set experiment parameters
type = 'classification';
maxepoch = 1000;
gradbatchsize = 1000;
batchsize = 100;
arch = [62];
activations = {'softmax'};
objfun = 'softmax-entropy';
corruption = 0.2;
verbose = 5;

% Pack parameters
params.type = type;
params.maxepoch = maxepoch;
params.batchsize = batchsize;
params.gradbatchsize = gradbatchsize;
params.arch = arch;
params.activations = activations;
params.objfun = objfun;
params.corruption = corruption;
params.verbose = verbose;

%------------------------------------------------------------------------------------------

% Train stochastic HF
[theta, results, params] = train_hf(train, train_labels, test, test_labels, params);


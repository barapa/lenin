% Experiment on USPS dataset
addpath('data'); addpath('code');
load usps_all
load usps_perms

% Select run (1-5)
inds = perms1;

% Preprocess data
% Uses an equal number of digits from each class
train = []; test = []; train_L = []; test_L = []; train_labels = []; test_labels = [];
e = eye(10);
for i=1:10
    train = [train; data(:,inds(1:800),i)'];
    test = [test; data(:, inds(801:1100),i)'];
    train_L = [train_L; ones(800,1)*i];
    test_L = [test_L; ones(300,1)*i];
    train_labels = [train_labels; repmat(e(i,:),800,1)];
    test_labels = [test_labels; repmat(e(i,:),300,1)];
end
train = double(train); test = double(test);
train = train ./ 255; test = test ./ 255;

% Scale data
[train, scaleparams] = standard(train);
test = standard(test, scaleparams);

%------------------------------------------------------------------------------------------

% Set experiment parameters
type = 'classification';
maxepoch = 10;
gradbatchsize = 1000;
batchsize = 100;
arch = [500 10];
activations = {'ReLU', 'softmax'};
objfun = 'softmax-entropy';
corruption = 0.5;
verbose = 1;

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


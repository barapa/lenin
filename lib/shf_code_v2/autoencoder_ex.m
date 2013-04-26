% Example script for training a deep denoysing autoencoder on USPS
addpath('data'); addpath('code');
load usps_all
load usps_perms

% Select run (1-5)
inds = perms1;

% Preprocess data
% Uses an equal number of digits from each class
train = []; test = [];
e = eye(10);
for i=1:10
    train = [train; data(:,inds(1:800),i)'];
    test = [test; data(:, inds(801:1100),i)'];
end
train = double(train); test = double(test);
train = train ./ 255; test = test ./ 255;

%------------------------------------------------------------------------------------------

% Set experiment parameters
type = 'autoencoder';
maxepoch = 50;
gradbatchsize = 1000;
batchsize = 100;
arch = [500 250 100 30 100 250 500 256];
activations = {'ReLU', 'ReLU', 'ReLU', 'linear', 'ReLU', 'ReLU', 'ReLU', 'logistic'};
objfun = 'cross-entropy';
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
[theta, results, params] = train_hf(train, train, test, test, params);


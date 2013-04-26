% Experiment on MNIST dataset
addpath('data'); addpath('code');

% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

digitdata=[]; 
targets=[];
train_L = [];
load digit0; digitdata = [digitdata; D]; targets = [targets; repmat([1 0 0 0 0 0 0 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*0]; 
load digit1; digitdata = [digitdata; D]; targets = [targets; repmat([0 1 0 0 0 0 0 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*1];
load digit2; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 1 0 0 0 0 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*2];
load digit3; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 1 0 0 0 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*3];
load digit4; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 1 0 0 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*4];
load digit5; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 1 0 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*5];
load digit6; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 1 0 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*6];
load digit7; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 0 1 0 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*7];
load digit8; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 0 0 1 0], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*8];
load digit9; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 0 0 0 1], size(D,1), 1)]; train_L = [train_L; ones(size(D,1),1)*9];
digitdata = digitdata/255;

totnum=size(digitdata,1);
fprintf(1, 'Size of the training dataset= %5d \n', totnum);

train = digitdata;
train_labels = targets;

clear digitdata targets;

digitdata=[];
targets=[];
test_L = [];
load test0; digitdata = [digitdata; D]; targets = [targets; repmat([1 0 0 0 0 0 0 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*0];
load test1; digitdata = [digitdata; D]; targets = [targets; repmat([0 1 0 0 0 0 0 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*1];
load test2; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 1 0 0 0 0 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*2];
load test3; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 1 0 0 0 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*3];
load test4; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 1 0 0 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*4];
load test5; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 1 0 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*5];
load test6; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 1 0 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*6];
load test7; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 0 1 0 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*7];
load test8; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 0 0 1 0], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*8];
load test9; digitdata = [digitdata; D]; targets = [targets; repmat([0 0 0 0 0 0 0 0 0 1], size(D,1), 1)]; test_L = [test_L; ones(size(D,1),1)*9];
digitdata = digitdata/255;

totnum=size(digitdata,1);
fprintf(1, 'Size of the test dataset= %5d \n', totnum);

test = digitdata;
test_labels = targets;

clear digitdata targets D totnum;

% Scale data
[train, scaleparams] = standard(train);
test = standard(test, scaleparams);

%------------------------------------------------------------------------------------------

% Set experiment parameters
type = 'classification';
maxepoch = 500;
gradbatchsize = 1000;
batchsize = 100;
arch = [1200 1200 10];
activations = {'ReLU', 'ReLU', 'softmax'};
objfun = 'softmax-entropy';
corruption = 0.5;
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


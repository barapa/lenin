% Prepare matlab path for our codebase and dependencies.
%
% NOTE: Assumes being run from top-level of repo.
%
IS_DIR = 7 ;
disp(sprintf('setting up paths...')) ;

  path('lib/audioread', path) ;
  path('lib/fuf', path) ;
  addpath(genpath('lib/DeepLearnToolbox'));
  addpath(genpath('lib/shift/'));
  path('lib/HessianFree', path);
  path('lib/HessianFree/code', path);
  path('lib/HessianFree/run_scripts', path);
  path('src/dbn', path) ;
  path('src/nn', path) ;
  path('src/postprocessing/', path) ;
  path('src/preprocessing/', path) ;
  path('src/sae', path) ;
  path('src/scripts/', path) ;
  if exist('src/scripts/smrz') == IS_DIR
    path('src/scripts/smrz/', path) ;
  end
  path('src/svm_hmm', path) ;
  path('src/util/', path) ;
  path('src/wrappers', path) ;
  %path('lib/shf_code_v2', path);
  %path('lib/shf_code_v2/code', path);


disp(sprintf('...done')) ;

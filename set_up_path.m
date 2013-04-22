% Prepare matlab path for STFT code.
%
% NOTE: Assumes being run from top-level of repo.
%
%
%function set_up_path
  disp(sprintf('setting up paths...')) ;

  path('lib/audioread', path) ;
  path('lib/fuf', path) ;
  addpath(genpath('lib/DeepLearnToolbox'));
  path('src/dbn', path) ;
  path('src/nn', path) ;
  path('src/postprocessing/', path) ;
  path('src/preprocessing/', path) ;
  path('src/scripts/', path) ;
  if exist('src/scripts/smrz') == 7
    path('src/scripts/smrz/', path) ;
  end
  path('src/svm_hmm', path) ;
  path('src/util/', path) ;
  path('src/wrappers', path) ;

  disp(sprintf('...done')) ;

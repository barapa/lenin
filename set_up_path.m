% Prepare matlab path for STFT code.
%
% NOTE: Assumes being run from top-level of repo.
%
%
%function set_up_path
  disp(sprintf('setting up paths...')) ;

  path('lib/audioread', path) ;
  path('src/preprocessing/', path) ;
  path('src/scripts/', path) ;

  disp(sprintf('...done')) ;

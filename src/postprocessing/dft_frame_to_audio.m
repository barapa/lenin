% function [ ] = dft_frame_to_audio( dft_frame, out_filename )
% 
% Convert a single frame of a dft and convert it into a wav file that can
% be listened to. For use with playing the optimal node activation
%
% dft_frame   : Column vector representing a single frame of a DFT
% out_filename: Absolute path (string) for name of audio file to write
% audio_length: (optional) length in frames of output audio. default=100
function [ ] = dft_frame_to_audio( dft_frame, out_filename, audio_length )
  NFFT_POINTS = 1024;
  WINDOW_OVERLAP = 512;
  WINDOW_SIZE = 1024;
  SAMPLE_RATE = 16000;

  if nargin < 3
    audio_length = 100;
  end
  
  rep_dft_frame = repmat(dft_frame, 1, audio_length);
  inverse_dft = istft(rep_dft_frame, NFFT_POINTS, WINDOW_OVERLAP, WINDOW_SIZE);
  audiowrite(inverse_dft, SAMPLE_RATE, out_filename);
end


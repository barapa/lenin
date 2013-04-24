% function [ new_features ] = construct_features_with_left_and_right_frames(...
%     features, left_frame_number, right_frame_number )
% 
% Appends the specified number of left and right frames to each feature vector
% 
% features: DxN matrix of features
% left_frame_number : the number of frames to the left to include in new
%                     feature vector
% right_frame_numner : the number of frames to the right to include in new
%                      feature vector
% 
% new_features : a (D + (left_frame_number*D) + (right_frame_number*D)) x N matrix
%                of features where the left and right frames are included in
%                each as specified by params.

function [ new_features ] = construct_features_with_left_and_right_frames(...
    features, left_frame_number, right_frame_number )

left_frames = cell(left_frame_number, 1);
right_frames = cell(right_frame_number, 1);

for left = 1 : left_frame_number
    % shift whole feature matrix to the right by i frames, padding with
    % zero
    left_frames{left} = shiftr(features, 0, left, 0);
end

for right = 1 : right_frame_number
    right_frames{right} = shiftl(features, 0, right, 0);
end

new_features = vertcat(features, left_frames{:}, right_frames{:});

end


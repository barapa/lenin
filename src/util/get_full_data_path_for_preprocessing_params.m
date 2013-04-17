% function [ full_path ] = get_full_data_path_for_preprocessing_params(...
%     window_size, window_overlap )
% 
% Gets the full path of the directory containing the preprocessed beatles
% music as speicifed by the preprocessing parameters.
% 
% window_size : window size of fsft
% window_overlap : window overlap of fsft
% 
% full_path : the full path string of the directory containing the files
% 
% ex. get_full_data_path_for_preprocessing_params(1024, 512) will return
% '/var/data/lenin/beatles_preprocessed/1024_512/'

function [ full_path ] = get_full_data_path_for_preprocessing_params(...
    window_size, window_overlap )

PARENT_DIR = '/var/data/lenin/beatles_preprocessed/' ;
child_dir = [num2str(window_size) '_' num2str(window_overlap) '/'];

full_path = strcat(PARENT_DIR, child_dir);

end


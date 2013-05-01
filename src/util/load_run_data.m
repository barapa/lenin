% function [ train_file_names, test_file_names ] = load_run_data(...
%     run_number, percentage_train)
% 
% Loads the cell arrays containing the training, testing and validation
% filenames for each run, given the specified run number and percentage training.
% 
% run_number : integer between 1 and 10
% percentage_train : 30, 60, or 90

function [ train_file_names, test_file_names, validation_file_names] =...
  load_run_data(run_number, percentage_train)
    
train_file = 'labeled_train_filenames.mat';
test_file = 'test_filenames.mat';
validation_file = 'validation_filenames.mat'

RUNS_DIR = 'data/runs/';
NUMBERED_RUN_DIRS = {'01/', '02/', '03/', '04/', '05/', '06/', '07/',...
    '08/', '09/', '10/'};
VALID_PERCENTAGES = [30, 60, 90];

% check for valid run numbers and percentages
if ~any(VALID_PERCENTAGES == percentage_train)
    error('[load_run_data] Invalid percentage specified.');
end

if run_number < 1 || run_number > 10
    error('[load_run_data] Invalid run number specified.');
end

numbered_run_dir_str = NUMBERED_RUN_DIRS{run_number};
percentage_dir_str = [num2str(percentage_train) '/'];
full_path = strcat(RUNS_DIR, numbered_run_dir_str, percentage_dir_str);

train_data = load(strcat(full_path, train_file));
train_file_names = train_data.labeled_train_filenames;

test_data = load(strcat(full_path, test_file));
test_file_names = test_data.test_filenames;

validation_data = load(strcat(full_path, validation_file));
validation_file_names = validation_data.validation_filenames;

end

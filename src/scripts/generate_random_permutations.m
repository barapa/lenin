% Generates num_permutations random permutatiosn of the data found in
% /var/data/lenin/matlab.
%
% Saves files in: /var/data/lenin/runs
%
% e.g., /var/data/lenin/runs/01/ will contain:
%           - labeled_train_filenamess.mat - cell array of filenames to use for
%                                            training.
%           - test_filenames.mat - cell array of filenames to use for testing
%                                       (also labeled).
%
function [ ] = generate_random_permutations(num_permutations)
  LABELED_DATA_DIR = '/var/data/lenin/matlab/labeled/' ;

  labeled_files = dir(LABELED_DATA_DIR) ;
  % remove '.' and '..' directories from labeled_files: 
  labeled_files = labeled_files(3 : length(labeled_files) ) ;
  files = {} ;

  % filenames are relative right now, we want to them to be absolute.
  for i = 1 : length(labeled_files)
    labeled_files(i).name = strcat(LABELED_DATA_DIR, labeled_files(i).name) ;
    files{i} = labeled_files(i).name ;
  end

  for i = 1 : num_permutations
    new_order = randperm(length(labeled_files)) ;
    files = files(new_order) ;
    write_data(files, i) ;
  end


function write_data(files, index)
  SAVE_DIR = '/var/data/lenin/runs/' ;

  num_string = num2str(index) ;
  if length(num_string) == 1
    num_string = strcat('0', num_string) ;
  end

  disp(sprintf('[generate_random_permutations] Making dir: %s', ...
      strcat(SAVE_DIR, num_string))) ;
  mkdir(SAVE_DIR, num_string) ;

  run_dir = strcat(SAVE_DIR, num_string, '/') ;

  test_percent = floor(length(files) / 10) ;

  test_filenames = files(length(files) - test_percent : length(files)) ;

  for i=30:30:100
    percent = i / 100 ;

    max_index = floor(length(files) *  percent)  ;

    disp(sprintf('[generate_random_permutations] Making dir: %s', ...
        strcat(run_dir, int2str(i)))) ;
    mkdir(run_dir, int2str(i)) ;
    percent_dir = strcat(run_dir, int2str(i), '/') ;

    labeled_train_filenames = files(1 : max_index) ;
    filename = strcat(percent_dir, 'labeled_train_filenames.mat') ;
    save(filename, 'labeled_train_filenames') ;
    disp(sprintf('[generate_random_permutaitons] Saving file: %s', filename)) ;
    filename = strcat(percent_dir, 'test_filenames.mat') ;
    disp(sprintf('[generate_random_permutations] Saving file: %s', filename)) ;
    save(filename, 'test_filenames') ;

  end







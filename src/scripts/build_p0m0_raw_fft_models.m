% Build the training files for training p0m0-raw-fft models
%
% Currently configured to only generate 30% files.
%
% Expectations:
% - /var/data/lenin/runs/* exists and is properly filled.
% - /var/data/lenin/models/* exists
%
function [ ] = build_p0m0_raw_fft_models()
  RUN_DIRS = '/var/data/lenin/runs/' ;
  MODEL_DIR = '/var/data/lenin/models/p0m0-raw-fft/' ;
  MODEL_NAME = 'p0m0-raw-fft.dat' ;
  MIN_PERCENT = 30 ;
  PERCENT_GAP = 30 ;
  MAX_PERCENT = 30 ;

  mkdir(MODEL_DIR) ;

  for run = 1 : 1 : 10

    num_string = num2str(run) ;
    if length(num_string) == 1
      num_string = strcat('0', num_string) ;
    end

    run_dir = strcat(num_string, '/') ;
    disp(sprintf('[build_p0m0_models] Making dir: %s', ...
        strcat(MODEL_DIR, run_dir))) ;
    mkdir(MODEL_DIR, run_dir) ;

    for percent = MIN_PERCENT : PERCENT_GAP : MAX_PERCENT

      percent = int2str(percent) ;
      percent_parent_dir = strcat(MODEL_DIR, run_dir);
      percent_dir = strcat(percent, '/' ) ;
      disp(sprintf('[build_p0m0_models] Making dir: %s', ...
          strcat(percent_parent_dir, percent_dir))) ;
      mkdir(percent_parent_dir, percent_dir) ;

      run_file = strcat(...
          RUN_DIRS, num_string, '/', percent, '/labeled_train_filenames.mat') ;
      test_file = strcat(...
          RUN_DIRS, num_string, '/', percent, '/test_filenames.mat') ;

      model_filename = strcat(percent_parent_dir, percent_dir, MODEL_NAME) ;
      disp(sprintf('[build p0m0_models] Making file: %s', model_filename)) ;
      model_file = fopen(model_filename, 'w') ;

      load(run_file) ;
      load(test_file) ;
      num_songs = length(labeled_train_filenames) ;

      for i = 1 : num_songs

        lab_train_filenames = labeled_train_filenames(:, i) ;
        load(lab_train_filenames{1}) ;

        disp(sprintf('------------------------------------------------'));
        disp(sprintf('total percent done: %f', (i / num_songs))) ;
        lines = format_data_for_struct_svm(song, i) ;
        format_string = repmat('%s\n', 1, length(lines)) ;
        size(lines)
        disp(sprintf('writing %s to file', song.filename));
        fprintf(model_file, format_string, lines);

      end % for i = 1 : num_songs

      fclose(model_name) ;

    end

  end % for run = 1 : 1 : 10

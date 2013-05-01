[params] = function create_dbn_save_params(dbn, dbn_training_params,...
  dbn_network_params, dbn_train_song_filenames, nn_train_song_filenames,...
  nn_validation_filenames, nn_test_filenames, nn_training_params,...
  run, nn_train_percentage, dbn_train_percentage,...
  notes, preprocessing_params, dbn_cdk, is_chroma)

  params.dbn = dbn;
  params.dbn_training_params = dbn_training_params;
  params.dbn_network_params = dbn_network_params;
  params.dbn_train_song_filenames = dbn_train_song_filenames;
  params.nn_train_song_filenames = nn_train_song_filenames;
  params.nn_validation_filenames = nn_validation_filenames;
  params.nn_test_filenames = nn_test_filenames;
  params.nn_training_params = nn_training_params;
  params.run = run;
  params.nn_train_percentage = nn_train_percentage;
  params.dbn_train_percentage = dbn_train_percentage;
  params.notes = notes;
  params.preprocessing_params = preprocessing_params;
  params.dbn_cdk = dbn_cdk;
  params.is_chroma = is_chroma;
  params.model_filename = ['rbm_dbn_', datestr(now, 'yyyymmddTHHMMSS')];

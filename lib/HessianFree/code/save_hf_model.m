function [ full_path_name ] = save_hf_model( model_name,...
    train_song_names,...
    validation_song_names,...
    test_song_names,...
    standardize_params,...
    paramsp,...
    layersizes,...
    layertypes,...
    run,...
    dbn_train_percentage,...
    numchunks,...
    numchunks_test,...
    runDesc,...
    errtype,...
    weightcost,...
    left_frames_network,...
    right_frames_network,...
    maxepoch,...
    rms,...
    mattype,...
    decay,...
    train_ll,...
    validation_ll,...
    ll_record,...
    train_err,...
    validation_err,...
    err_record,...
    preprocessing_params,...
    is_chroma)

hf_dir_name = '/var/data/lenin/hessian_free_models/';
pathname = [hf_dir_name model_name '/final/'];
ensure_dir_exists(pathname);
full_path_name = [pathname model_name];

save(full_path_name,...
    'model_name',...
    'train_song_names',...
    'validation_song_names',...
    'test_song_names',...
    'standardize_params',...
    'paramsp',...
    'layersizes',...
    'layertypes',...
    'run',...
    'dbn_train_percentage',...
    'numchunks',...
    'numchunks_test',...
    'runDesc',...
    'errtype',...
    'weightcost',...
    'left_frames_network',...
    'right_frames_network',...
    'maxepoch',...
    'rms',...
    'mattype',...
    'decay',...
    'train_ll',...
    'validation_ll',...
    'll_record',...
    'train_err',...
    'validation_err',...
    'err_record',...
    'preprocessing_params',...
    'is_chroma');
end


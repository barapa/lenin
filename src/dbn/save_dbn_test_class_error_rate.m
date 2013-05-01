[] = function save_dbn_test_class_error_rate(test_class_error_rate, model_filename)

save_dir = '/var/data/lenin/rbm_dbn_models/';
ensure_dir_exists(save_dir);

file_path = [save_dir, filename];

save(file_path, 'test_class_error_rate', '-append');

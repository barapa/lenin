function [ full_path_name ] = save_classification_rates_to_model( model_name,...
  train_class_err, test_class_err, validation_class_err)

hf_dir_name = '/var/data/lenin/hessian_free_models/';
pathname = [hf_dir_name model_name '/final/'];
full_path_name = [pathname model_name];

save(full_path_name, 'train_class_err', 'test_class_err',...
  'validation_class_err', '-append')

end

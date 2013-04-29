% function model = load_hf_model(model_name)
% model_name: is just the name of the model without any path. Ex.
%             shf_20130426T210722

function model = load_hf_model(model_name)

hf_dir_name = '/var/data/lenin/hessian_free_models/';
pathname = [hf_dir_name model_name '/final/'];
full_path_name = [pathname model_name];
model = load(full_path_name);

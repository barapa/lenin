% function [ model ] = load_trainined_model( model_full_path )
% 
% Takes the full path of a saved trained model and returns it.
% 
% model_full_path: the full path of a model

function [ model ] = load_trained_model( model_full_path )
model_full_path
model = load(model_full_path);
end

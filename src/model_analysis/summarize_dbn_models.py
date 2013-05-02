#!/usr/bin/env python
'''
Assumes the environment variable 'LENIN_DATA_PATH' is set. For example, it
might be set to '/var/data/lenin'
'''
import os
import scipy.io
import glob
import csv

LENIN_DATA_PATH = os.environ['LENIN_DATA_PATH']
SUMMARY_FILE_NAME = 'dbn_model_summary.csv'
RBM_MODELS_DIR = 'rbm_dbn_models'
MODEL_FIELDS = [
    'model_pathname',
    'is_chroma',
    'nn_test_error_rate',
    'nn_validation_error_rate',
    'run',
    'window_size',
    'window_overlap',
    'preprocessing_epsilon',
    'preprocessing_k',
    'left_frames',
    'right_frames',
    'dbn_cdk',
    'dbn_train_percentage',
    'dbn_layer_sizes', 
    'dbn_is_visible_layer_gaussian',
    'dbn_num_epochs',
    'dbn_song_batch_size',
    'dbn_mini_batch_size',
    'dbn_momentum',
    'dbn_binary_learning_rate',
    'dbn_gaussian_learning_rate',
    'nn_train_percentage',
    'nn_song_batch_size',
    'nn_num_epochs',
    'nn_batch_size',
    'nn_learning_rate',
    'nn_activation_function',
    'nn_momentum',
    'nn_output',
    'nn_scaling_learning_rate',
    'nn_weight_penalty_L2',
    'nn_non_sparsity_penalty',
    'nn_sparsity_target',
    'nn_input_zero_masked_fraction',
    'nn_dropout_fraction',
    'nn_layer_sizes',
    'notes']

def summarize_models_and_save():
  model_paths = get_model_file_paths()
  summary_file = open(os.path.join(LENIN_DATA_PATH, SUMMARY_FILE_NAME), 'wb')
  writer = csv.writer(summary_file)
  writer.writerow(get_header_row())

  for model_path in model_paths:
    model = load_model(model_path)
    writer.writerow(get_model_row_str(model_path, model))

  summary_file.close()

def get_model_file_paths():
  '''
  Returns a list of the full paths of all of the .mat files present in the
  RBM_MODELS_DIR.
  '''
  return glob.glob(os.path.join(LENIN_DATA_PATH, RBM_MODELS_DIR, '*.mat'))

def load_model(model_full_path):
  '''
  Returns a model object, which is a dictionary containing the fields of an
  RBM model
  '''
  return scipy.io.loadmat(model_full_path, squeeze_me=True,
      struct_as_record=False)

def handle_missing_field(function):
  def handle_problems(model):
    try:
      return function(model)
    except Exception:
      return 'null'
  
  return handle_problems

def get_header_row():
  return MODEL_FIELDS

def get_model_row_str(model_path, model):
  return [
    model_path,
    get_is_chroma(model),
    get_nn_test_error_rate(model),
    get_nn_validation_error_rate(model),
    get_run(model),
    get_window_size(model),
    get_window_overlap(model),
    get_preprocessing_epsilon(model),
    get_preprocessing_k(model),
    get_data_include_left(model),
    get_data_include_right(model),
    get_dbn_cdk(model),
    get_data_include_left(model),
    get_data_include_right(model),
    get_dbn_train_percentage(model),
    get_dbn_layer_sizes(model),
    get_dbn_is_visible_layer_gaussian(model),
    get_dbn_num_epochs(model),
    get_dbn_song_batch_size(model),
    get_dbn_mini_batch_size(model),
    get_dbn_momentum(model),
    get_dbn_binary_learning_rate(model),
    get_dbn_gaussian_learning_rate(model),
    get_nn_train_percentage(model),
    get_nn_song_batch_size(model),
    get_nn_num_epochs(model),
    get_nn_batch_size(model),
    get_nn_learning_rate(model),
    get_nn_activation_function(model),
    get_nn_momentum(model),
    get_nn_output(model),
    get_nn_scaling_learning_rate(model),
    get_nn_weight_penalty_L2(model),
    get_nn_non_sparsity_penalty(model),
    get_nn_sparsity_target(model),
    get_nn_input_zero_masked_fraction(model),
    get_nn_dropout_fraction(model),
    get_nn_layer_sizes(model),
    get_notes(model)]
    
@handle_missing_field
def get_is_chroma(model):
  return str(model['is_chroma'])

@handle_missing_field
def get_nn_test_error_rate(model):
  return str(model['test_class_error_rate'])

@handle_missing_field
def get_nn_validation_error_rate(model):
  return str(model['error_rate'])

@handle_missing_field
def get_run(model):
  return str(model['run'])

@handle_missing_field
def get_window_size(model):
  return str(model['preprocessing_params'].window_size)

@handle_missing_field
def get_window_overlap(model):
  return str(model['preprocessing_params'].window_overlap)

@handle_missing_field
def get_preprocessing_epsilon(model):
  return str(model['preprocessing_params'].epsilon)

@handle_missing_field
def get_preprocessing_k(model):
  return str(model['preprocessing_params'].k)

@handle_missing_field
def get_dbn_train_percentage(model):
  return str(model['dbn_train_percentage'])

@handle_missing_field
def get_dbn_layer_sizes(model):
  return str(model['dbn'].sizes)

@handle_missing_field
def get_dbn_is_visible_layer_gaussian(model):
  return str(model['dbn'].gaussian_visible_units)

@handle_missing_field
def get_dbn_num_epochs(model):
  return str(model['dbn_training_params'].num_epochs)

@handle_missing_field
def get_dbn_song_batch_size(model):
  return str(model['dbn_training_params'].song_batch_size)

@handle_missing_field
def get_dbn_mini_batch_size(model):
  return str(model['dbn_training_params'].mini_batch_size)

@handle_missing_field
def get_dbn_momentum(model):
  return str(model['dbn_training_params'].momentum)

@handle_missing_field
def get_dbn_binary_learning_rate(model):
  return str(model['dbn_training_params'].binary_learning_rate)

@handle_missing_field
def get_dbn_gaussian_learning_rate(model):
  return str(model['dbn_training_params'].gaussian_learning_rate)

@handle_missing_field
def get_nn_train_percentage(model):
  return str(model['nn_train_percentage'])

@handle_missing_field
def get_nn_song_batch_size(model):
  return str(model['nn_training_params'].song_batch_size)

@handle_missing_field
def get_nn_num_epochs(model):
  return str(model['nn_training_params'].num_epochs)

@handle_missing_field
def get_nn_batch_size(model):
  return str(model['nn_training_params'].batch_size)

@handle_missing_field
def get_nn_learning_rate(model):
  return str(model['nn_training_params'].learning_rate)

@handle_missing_field
def get_nn_activation_function(model):
  return str(model['nn_training_params'].activation_function)

@handle_missing_field
def get_nn_momentum(model):
  return str(model['nn_training_params'].momentum)

@handle_missing_field
def get_nn_output(model):
  return str(model['nn_training_params'].output)

@handle_missing_field
def get_nn_scaling_learning_rate(model):
  return str(model['nn_training_params'].scaling_learning_rate)

@handle_missing_field
def get_nn_weight_penalty_L2(model):
  return str(model['nn_training_params'].weight_penalty_L2)

@handle_missing_field
def get_nn_non_sparsity_penalty(model):
  return str(model['nn_training_params'].non_sparsity_penalty)

@handle_missing_field
def get_nn_sparsity_target(model):
  return str(model['nn_training_params'].sparsity_target)

@handle_missing_field
def get_nn_input_zero_masked_fraction(model):
  return str(model['nn_training_params'].input_zero_masked_fraction)

@handle_missing_field
def get_nn_dropout_fraction(model):
  return str(model['nn_training_params'].dropout_fraction)

@handle_missing_field
def get_nn_layer_sizes(model):
  return str(model['nn'].size)

@handle_missing_field
def get_notes(model):
  return str.replace(str(model['notes']), ',', ';') # replace commas with semicolons

@handle_missing_field
def get_dbn_cdk(model):
  return str(model['dbn_cdk'])

@handle_missing_field
def get_data_include_left(model):
  return str(model['preprocessing_params'].data_include_left)

@handle_missing_field
def get_data_include_right(model):
  return str(model['preprocessing_params'].data_include_right)

def main():
  summarize_models_and_save()

if __name__ == '__main__':
  main()

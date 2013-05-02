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
SUMMARY_FILE_NAME = 'hf_model_summary.tsv'
HF_MODELS_DIR = 'hessian_free_models'
FINAL_MODELS_DIR = 'final'
COLUMN_NAMES_ORDERED =\
  ['model_name',
   'runDesc',
   'is_chroma',
   'run',
   'test_class_err',
   'validation_class_err',
   'train_class_err',
   'layersizes',
   'layertypes',
   'left_frames_network',
   'right_frames_network',
   'dbn_train_percentage',
   'decay',
   'weightcost',
   'train_ll',
   'validation_ll',
   'mattype',
   'maxepoch',
   'numchunks_test',
   'numchunks',
   'errtype',
   'rms']
DELIMITER = '\t'

def summarize_models_and_save():
  model_paths = get_model_full_paths()
  summary_file = open(os.path.join(LENIN_DATA_PATH, SUMMARY_FILE_NAME), 'wb')
  writer = csv.DictWriter(summary_file, fieldnames=COLUMN_NAMES_ORDERED,
      delimiter=DELIMITER, extrasaction='ignore')
  writer.writeheader()

  for model_path in model_paths:
    model = load_model(model_path)
    writer.writerow(model)

  summary_file.close()

def get_model_full_paths():
  model_dirs = get_model_dirs()
  model_paths = [glob.glob(os.path.join(x, FINAL_MODELS_DIR, '*.mat')) for x in\
      model_dirs]
  # flatten list
  model_paths = [item for sublist in model_paths for item in sublist]
  return model_paths


def get_model_dirs():
  '''
  Returns a list of the full paths of the directories of each model
  '''
  models = glob.glob(os.path.join(LENIN_DATA_PATH, HF_MODELS_DIR, 'shf*'))
  models = [x for x in models if x]
  return models

def get_model_path_from_dir(model_dir):
  '''
  Returns the full path of the .mat file for the model in the final dir in the
  given model dir.
  '''
  model = glob.glob(os.path.join(model_dir, FINAL_MODELS_DIR, '*.mat'))
  if len(model) == 0:
    model = ''
  elif len(model) == 1:
    model = model[0]
  else:
    raise Exception(model_dir + ' has too many models in it.')
  return model

def load_model(model_full_path):
  return scipy.io.loadmat(model_full_path, squeeze_me=True,
      struct_as_record=False)

def handle_missing_field(function):
  def handle_problems(model):
    try:
      return function(model)
    except Exception:
      return 'null'

def main():
  summarize_models_and_save()

if __name__ == '__main__':
  main()

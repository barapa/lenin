"""
generate_run_scripts.py: generate SVM_HMM run scripts for all models found in
    $LENIN_DATA_PATH (this path should be something like /var/data/lenin, see
    get_started.txt for more information).

    DBN run scripts: data/scripts/$USER/runs/dbn
    SHF run scripts: data/scripts/$USER/runs/shf 
    SAE run scripts: data/scripts/$USER/runs/sae

NOTE: Expects to be run from the top-level of the repository.
NOTE: Outputs run scripts to data/scripts/$USER/runs
NOTE: Scripts generated expect svm_hmm_classify and svm_hmm_learn to be defined
      on path.
NOTE: Expects /bin/bash to exist and work.
NOTE: Expects you to be in the lenin virtualenv (see get_started.txt)
NOTE: Expects LENIN_DATA_PATH to be defined.
"""
import os
import sys


# These are paramters for the SVM_HMM model.
# C is the cost of slack (higher means we use less slack, and solutions take
# longer to be found).
C = 10
# E (epsilon) is the convergence parameter for the
# quadratic program that is being solved.
E = 0.5

BASH='/bin/bash'

def write_model_run_script(
    model_name, model_filename, run_script_dir, svm_dir):
  """
  Write run script for a particular model (model_name) and save it to
  the directory specified in run_script_dir. svm_dir tells us where the
  svm data lives, as well as where to write out model and prediction files.
  """
  print "Generating run script for model %s. Saving file in %s" % \
      (model_name, run_script_dir)
  run_script_filename = "%s/run_%s.sh" % (run_script_dir, model_name)
  run_script = open(run_script_filename, 'w')

  run_script.write("#!%s\n" % BASH)
  run_script.write("\n")
  run_script.write("MODEL_NAME=\"%s\"\n" % model_filename)
  run_script.write("MODEL_PATH=\"%s/${MODEL_NAME}\"\n" % svm_dir)

  input_files = os.listdir("%s/%s/train" % (svm_dir, model_filename))
  input_files = filter(lambda x: 'data' in x, input_files)

  for input_file in input_files:
    layers = input_file.split('.')[0]
    run_script.write("TRAIN_PATH=\"${MODEL_PATH}/train/%s\"\n" % input_file)
    run_script.write(
        "MODEL_SAVE_PATH=\"${MODEL_PATH}/train/%s_c_%d_e_%f.model\"\n" %
        (layers, C, E))
    run_script.write("TEST_PATH=\"${MODEL_PATH}/test/%s\"\n" % input_file)
    run_script.write(
        "PREDICTIONS_SAVE_PATH=\"${MODEL_PATH}/test/%s_c_%d_e_%f.predictions\"\n" %
        (layers, C, E))
    run_script.write("\n")
    run_script.write(
        'echo "svm_hmm_learn -c %d -e %f ${TRAIN_PATH} ${MODEL_SAVE_PATH}"\n' %
        (C, E))
    run_script.write(
        "svm_hmm_learn -c %d -e %f ${TRAIN_PATH} ${MODEL_SAVE_PATH}\n" %
        (C, E))
    run_script.write('echo "svm_hmm_classify ${TEST_PATH} ${MODEL_SAVE_PATH} ${PREDICTIONS_SAVE_PATH}"\n')
    run_script.write("svm_hmm_classify ${TEST_PATH} ${MODEL_SAVE_PATH} ${PREDICTIONS_SAVE_PATH}\n")
    run_script.write("\n")

  run_script.close()


def get_new_models(model_type, model_dir, run_script_dir):
  """
  Get model names (e.g. '20130422T00749') and model filenames (e.g.
  'sae_20130422T000749.mat') for models that don't have run scripts already
  generated. This is done by getting all models in model_dir (svm_hmm_data) and
  removing the models referenced from scripts in run_script_dir.

  Params:
    model_type - 'sae', 'shf', or 'rbm_dbn'
    model_dir - svm_hmm directory.
    run_script_dir - run scripts directory.

  Returns a list of tuples of pairs (model_name, model_file_name) for
  convenience.
  """
  all_models = os.listdir(model_dir)
  all_models_of_type = filter(lambda x: model_type in x, all_models)
  if model_type == 'rbm_dbn':
    all_models_of_type = convert_dbn_to_model_name(all_models_of_type)
  else:
    all_models_of_type = convert_sae_or_shf_to_model_name(all_models_of_type)
  all_scripts = os.listdir(run_script_dir)
  all_run_scripts = remove_non_run_scripts(all_scripts)
  existing_models_of_type = convert_run_to_model_name(all_run_scripts)
  new_models = \
      filter(lambda x: x not in existing_models_of_type, all_models_of_type)
  new_model_filenames = \
      map(lambda x: "%s_%s.mat" % (model_type, x), new_models)
  return zip(new_models, new_model_filenames)


def remove_non_run_scripts(existing_models):
  """
  Filter out non-run scripts. Just a precaution.
  """
  return filter(lambda x: 'run' in x and '.sh' in x, existing_models)


def convert_dbn_to_model_name(dbn_files):
  """
  Convert dbn model filenames (e.g. rbm_dbn_20130422T000749) into just
  model names (e.g. 20130422T000749).
  """
  return map(lambda x: x.split('_')[2], dbn_files)


def convert_sae_or_shf_to_model_name(sae_files):
  """
  Convert sae model filenames (e.g. sae_20130422T000749.mat) into just model
  names (e.g. 20130422T000749).
  """
  return map(lambda x: x.split('_')[1].split('.')[0], sae_files)


def convert_run_to_model_name(run_files):
  """
  Convert run script names (e.g., run_20130422T000749.sh) into just model
  names (e.g. 20130422T000749).
  """
  return map(lambda x: x.split("_")[1].split(".")[0], run_files)


def ensure_dir_exists(directory, path=None):
  """
  Ensures that a passed-in directory exists. If it doesn't already exist, makes
  the directory and notifies user of doing so.
  """
  full_path = "%s/%s" % (path, directory)
  if path is None:
    path = '.'
  if directory not in os.listdir(path):
    print "making dir: %s" % full_path
    os.mkdir("%s" % full_path)


def check_environs():
  """
  Ensures that all the appropriate directories already exist, and if not,
  makes them.
  """
  try:
    top_dir = os.environ["LENIN_DATA_PATH"]
  except:
    print "$LENIN_DATA_PATH not set! Nothing to do...."
    sys.exit(1)

  model_dir = "%s/svm_hmm_data" % top_dir

  ROOT = os.getcwd()
  ensure_dir_exists("src")
  ensure_dir_exists("scripts", "src")

  user = os.environ["USER"]
  ensure_dir_exists(user, "src/scripts")
  user_script_dir = "src/scripts/%s" % user

  ensure_dir_exists("runs", user_script_dir)
  run_script_dir = "%s/runs" % user_script_dir

  ensure_dir_exists("dbn", run_script_dir)
  dbn_script_dir = "%s/dbn" % run_script_dir

  ensure_dir_exists("sae", run_script_dir)
  sae_script_dir = "%s/sae" % run_script_dir

  ensure_dir_exists("shf", run_script_dir)
  shf_script_dir = "%s/shf" % run_script_dir

  return model_dir, dbn_script_dir, sae_script_dir, shf_script_dir


if __name__ == '__main__':
  svm_dir, dbn_script_dir, sae_script_dir, shf_script_dir = check_environs()

  #dbn_models_and_files = get_new_models('rbm_dbn', svm_dir, dbn_script_dir)
  #for model, filename in dbn_models_and_files:
  #  write_model_run_script(model, filename, dbn_script_dir, svm_dir)

  #sae_models_and_files = get_new_models('sae', svm_dir, sae_script_dir)
  #for model, filename in sae_models_and_files:
  #  write_model_run_script(model, filename, sae_script_dir, svm_dir)

  shf_models_and_files = get_new_models('shf', svm_dir, shf_script_dir)
  for model, filename in shf_models_and_files:
    write_model_run_script(model, filename, shf_script_dir, svm_dir)


"""
generate_run_scripts.py: generate SVM_HMM run scripts for all models found in
    $LENIN_DATA_PATH (this path should be something like /var/data/lenin, see
    get_started.txt for more information).

NOTE: Expects to be run from the top-level of the repository.
NOTE: Outputs run scripts to data/scripts/$USER/
NOTE: Scripts generated expect svm_hmm_classify and svm_hmm_learn to be defined
      on path.
NOTE: Expects /bin/bash to exist and work.
NOTE: Expects you to be in the lenin virtualenv (see get_started.txt)
"""
import os
import sys


# These are paramters for the SVM_HMM model.
# C is the cost of slack (higher means we use less slack, and solutions take
# longer to be found).
C = 10
# E (epsilon) is the convergence parameter for the
# quadratic program that is being solved.
E = 1.0

BASH='/bin/bash'

def generate_model_run_script(model_filename, run_script_dir, model_dir):
  # Transform data filename (e.g. rbm_dbn_20130422000749.mat) into just a model
  # name (e.g. 20130422000749.mat).
  model_name = model_filename.split("_")[2].split(".")[0]
  print "Generating run script for model %s. Saving file in %s" % \
      (model_name, run_script_dir)
  run_script_filename = "%s/run_%s.sh" % (run_script_dir, model_name)
  run_script = open(run_script_filename, 'w')

  run_script.write("#!%s\n" % BASH)
  run_script.write("\n")
  run_script.write("MODEL_NAME=\"%s\"\n" % model_filename)
  run_script.write("MODEL_PATH=\"%s/${MODEL_NAME}\"\n" % model_dir)

  input_files = os.listdir("%s/%s/train" % (model_dir, model_filename))
  input_files = filter(lambda x: 'data' in x, input_files)

  for input_file in input_files:
    layers = input_file.split('.')[0]
    run_script.write("TRAIN_PATH=\"${MODEL_PATH}/train/%s\"\n" % input_file)
    run_script.write(
        "MODEL_SAVE_PATH=\"${MODEL_PATH}/train/%s_c_%d_e_%f.model\"\n" %
        (layers, C, E))
    run_script.write("TEST_PATH=\"${MODEL_PATH}/test/%s\"\n" % input_file)
    run_script.write(
        "PREDICTIONS_SAVE_PATH=\"${MODEL_PATH}/test/%s_c_%d_e_%f.model\"\n" %
        (layers, C, E))
    run_script.write("\n")
    run_script.write(
        "svm_hmm_learn -c %d -e %f ${TRAIN_PATH} ${MODEL_SAVE_PATH}\n" %
        (C, E))
    run_script.write(
        "svm_hmm_classify ${TEST_PATH} ${MODEL_SAVE_PATH} ${PREDICTIONS_SAVE_PATH}\n")
    run_script.write("\n")

  run_script.close()

if __name__ == '__main__':
  try:
    top_dir = os.environ["LENIN_DATA_PATH"]
  except:
    print "$LENIN_DATA_PATH not set! Nothing to do...."
    sys.exit(1)

  ROOT = os.getcwd()
  
  model_dir = "%s/svm_hmm_data" % top_dir
  models = os.listdir(model_dir)

  user = os.environ["USER"]
  run_script_dir = "src/scripts/%s" % user

  if "src" not in os.listdir("."):
    os.mkdir("src")

  if "scripts" not in os.listdir("src/"):
    os.mkdir("src/scripts")

  if user not in os.listdir("src/scripts"):
    os.mkdir(run_script_dir)

  existing_models = os.listdir(run_script_dir)

  # Filter out non-run scripts in scripts dir:
  existing_models = \
      filter(lambda x: 'run' in x and '.sh' in x, existing_models)

  # convert run script names (e.g., run_20130422T000749.sh) into just model
  # names (e.g. 20130422T000749).
  existing_models = \
      map(lambda x: x.split("_")[1].split(".")[0], existing_models)

  # convert just model names (e.g., 20130422T000749) into svm_hmm data filenames
  # (e.g. rbm_dbn_20130422T000749.mat).
  existing_models = \
      map(lambda x: "rbm_dbn_%s.mat" % x, existing_models)

  # Remove any models from models that have run scripts already generated.
  models = filter(lambda x: x not in existing_models, models)

  map(lambda x: \
      generate_model_run_script(x, run_script_dir, model_dir), models)


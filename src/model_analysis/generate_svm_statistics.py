"""
generate_svm_statistics: generate performance for any new SVMs that were run.

  Appends all results to:      data/svms/raw_performance.csv
    (it's "raw" b/c its for single runs instead of averaging across runs).

  File structure is as follows:

    model_name, model_type, c_val, e_val, run, train_percentage, performance

  Where,

    model_name:       The name of the corresponding model that generated the
                      input for the svm.

    model_type:       'sae', 'hf', or 'rbm_dbn'

    c_val:            The value for C, the cost of slack used during SVM
                      solving.

    e_val:            The value of epsilon, used for a stopping criterion
                      during SVM solving.

    run:              Which run of the train vs. test data split was used.
                      Corresponds to data in data/runs/

    train_percentage: The amount of training data used (30, 60 or 90%).

    performance:      The accuracy at test.


NOTE: Will create data/svm/performance.csv if need be.
NOTE: Expects to be run from the top-level of the repository.
NOTE: Expects LENIN_DATA_PATH to be defined.
"""
import os
import sys


HEADER = "model_name,model_type,c_val,e_val,run,train_percentage,performance\n"
RESULTS_FILE_DIR = "data/svms"
RESULTS_FILE_NAME = "raw_performance.csv"


def get_new_models(existing_models):
  """
  Get a list of models for which we have predictions, but performance results
  aren't yet written to the results_file.
  """
  pass


def get_existing_models(results_file):
  """
  Get a list of existing model names from the results file, so we don't
  generate their results twice.

  Params:
    results_file - open file handle to the results file.

  Returns a list of model names found in results_file.
  """
  results_file.seek(0)
  # make sure we skip the header:
  lines = results_file.readlines()[1:]
  existing_models = map(lambda x: x.split(',')[0], lines)
  return existing_models


def ensure_results_file_exists():
  """
  Ensures that the results file exists. If so, opens it up in append mode.
  If it doesn't, creates file and also writes the HEADER to it, and returns it
  in write mode.
  """
  if "svms" not in os.listdir("data"):
    print "making dir: data/svms"
    os.mkdir(RESULTS_FILE_DIR)

  results_file = None
  results_file_full_name = "%s/%s" % (RESULTS_FILE_DIR, RESULTS_FILE_NAME)

  if RESULTS_FILE_NAME not in os.listdir(RESULTS_FILE_DIR):
    print "making results file for first time, writing header."
    results_file = open(results_file_full_name, 'w')
    results_file.write(HEADER)
  else:
    print "results file already exists, will be appending."
    results_file = open(results_file_full_name, 'a')

  return results_file


def write_new_models(new_models, results_file):
  for model in new_models:
    print 'working on %s' % model
    model_path = "/var/data/lenin/%s/test" % model
    listings = os.listdir(model_path)
    listings = filter(lambda x: 'model' in x, listings)
    true_labels_filename = "%s/true_labels.dat" % model_path
    true_labels_file = open(true_labels_filename, 'r')
    true_labels = true_labels_file.readlines()
    true_labels_file.close()
    for prediction_type in listings:
      prediction_filename = "%s/%s" % (model_path, prediction_type)
      prediction_file = open(prediction_filename, 'r')
      predictions = prediction_file.readlines()
      prediction_file.close()
      hit_count = 0
      for prediction, truth in zip(predictions, true_labels):
        if prediction == truth:
          hit_count += 1
      accuracy = float(hit_count) / len(predictions)
      print 'model: %s accuracy: %f, prediction_type: %s, hit count: %d, label count: %d' % \
          (model.split('/')[1], accuracy, prediction_type, hit_count, len(predictions))





if __name__ == "__main__":
  results_file = ensure_results_file_exists()
  #existing_models = get_existing_models(results_file)
  #new_models = get_new_models(existing_models)
  new_models = [ \
    # CHROMA svms:
    'svm_hmm_data/rbm_dbn_20130426T114047.mat',
    'svm_hmm_data/rbm_dbn_20130426T115242.mat',
    'svm_hmm_data/rbm_dbn_20130426T113045.mat',
    'svm_hmm_data/rbm_dbn_20130426T121558.mat',
    'svm_hmm_data/rbm_dbn_20130426T125949.mat',
    'svm_hmm_data/rbm_dbn_20130426T120405.mat',
    'svm_hmm_data/rbm_dbn_20130426T122544.mat',
    'svm_hmm_data/rbm_dbn_20130426T123710.mat',
    'svm_hmm_data/rbm_dbn_20130426T111902.mat',
    'svm_hmm_data/rbm_dbn_20130426T124818.mat',
    'svm_hmm_data/rbm_dbn_20130428T042207.mat',
    'svm_hmm_data/rbm_dbn_20130428T024456.mat',
    'svm_hmm_data/rbm_dbn_20130428T010049.mat',
    'svm_hmm_data/rbm_dbn_20130427T235546.mat',
    'svm_hmm_data/rbm_dbn_20130427T224935.mat',
    'svm_hmm_data/rbm_dbn_20130427T214046.mat',
    'svm_hmm_data/rbm_dbn_20130427T203641.mat',
    'svm_hmm_data/rbm_dbn_20130427T192740.mat',
    'svm_hmm_data/rbm_dbn_20130427T183023.mat',
    'svm_hmm_data/rbm_dbn_20130427T174436.mat']
  write_new_models(new_models, results_file)
  results_file.close()

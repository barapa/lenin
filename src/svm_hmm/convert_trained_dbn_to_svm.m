% function [ ] = convert_trained_dbn_to_svm( model_name,...
%     layers)
% 
% Takes the filename of a model (not including path) and a vector 
% of which layers to use and writes the svm training and testing data files

% model_name: filename of a trained dbn model. 
%             example: rbm_dbn_20130417T123919.mat
% layers:     (optional) a vector of integers indicating which layers of the
%             network to use to create the features. If left out, all
%             layers are used be default.

function [ ] = convert_trained_dbn_to_svm( model_name, layers)

RBM_MODEL_PATH = '/var/data/lenin/rbm_dbn_models/';
SVM_HMM_DATA_PATH = '/var/data/lenin/svm_hmm_data/';

mkdir(SVM_HMM_DATA_PATH); % in case it doesn't exist

% load in model
model = load_trained_model(strcat(RBM_MODEL_PATH, model_name));

% get data from model formatted for svm
if nargin == 1
    [ train_features, train_labels, train_song_names, test_features,...
        test_labels, test_song_names] = get_model_activations_for_svm_hmm(...
        model ); 
else % if layers is passed
    [ train_features, train_labels, train_song_names, test_features,...
        test_labels, test_song_names] = get_model_activations_for_svm_hmm(...
        model, layers ); 
end

% write training svm data
svm_train_model_dir = strcat(SVM_HMM_DATA_PATH, model_name, '/train/');
mkdir(svm_train_model_dir);
create_svm_data_files(svm_train_model_dir, train_features, train_labels,...
    train_song_names )

% write testing svm data
svm_test_model_dir = strcat(SVM_HMM_DATA_PATH, model_name, '/test/');
mkdir(svm_test_model_dir);
create_svm_data_files(svm_test_model_dir, test_features, test_labels,...
    test_song_names )

end


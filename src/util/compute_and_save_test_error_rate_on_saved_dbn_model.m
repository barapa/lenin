function [ error_rate, errors ] = compute_and_save_test_error_rate_on_saved_dbn_model(...
    model_name)

model_dir = '/var/data/lenin/rbm_dbn_models/';
model_path = [model_dir, model_name];
model = load_trained_model(model_path);


disp('Loading testing data...') ;
[ test_nn_x, ~, test_nn_y ] = load_songs(model.test_nn_songs,...
  model.preprocessing_params) ;
disp('...done');

% if its not chroma model, we need to whiten
if ~model.is_chroma
    disp('whitening song batch');

    test_nn_x = whiten_data(test_nn_x, model.preprocessing_params.X_avg,...
        model.preprocessing_params.W);
end

test_nn_x = construct_features_with_left_and_right_frames(...
     test_nn_x,...
     model.preprocessing_params.data_include_left,...
     model.preprocessing_params.data_include_right);


[ error_rate, errors ] = nntest(model.nn, test_nn_x', test_nn_y') ;
disp(sprintf('Neural Network Softmax Error Rate: %s', num2str(error_rate))) ;
save_dbn_test_class_error_rate(error_rate, model_name);

end


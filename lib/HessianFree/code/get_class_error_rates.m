% Takes a model in a final folder, and computes the error rates on its training,
% testing and validation set. 

function [train_err, validation_err, test_err] = get_class_error_rates(model_name)

model = load_hf_model(model_name);
train_file_names = model.train_song_names;
test_file_names = model.test_song_names;
validation_file_names = model.validation_song_names;

[train_data, train_borders, train_one_hot_labels] = load_songs(train_file_names);
[test_data, test_borders, test_one_hot_labels] = load_songs(test_file_names);
[validation_data, validation_borders, validation_one_hot_labels] =...
  load_songs(validation_file_names);

% standardize the data
train_data = standardize(train_data, model.standardize_params);
test_data = standardize(test_data, model.standardize_params);
validation_data = standardize(validation_data, model.standardize_params);

% append left and right frames
train_data = construct_features_with_left_and_right_frames(...
  train_data, model.left_frames_network, model.right_frames_network);
test_data = construct_features_with_left_and_right_frames(...
  test_data, model.left_frames_network, model.right_frames_network);
validation_data = construct_features_with_left_and_right_frames(...
  validation_data, model.left_frames_network, model.right_frames_network);

% classify inputs and count the error rates
train_preds = classify_input(model.paramsp, train_data, model.layersizes,...
  model.layertypes);
test_preds = classify_input(model.paramsp, test_data, model.layersizes,...
  model.layertypes);
validation_preds = classify_input(model.paramsp, validation_data,...
  model.layersizes, model.layertypes);

train_err = 1 - mean(all(train_preds == train_one_hot_labels, 1));
test_err = 1 - mean(all(test_preds == test_one_hot_labels, 1));
validation_err = 1 - mean(all(validation_preds == validation_one_hot_labels, 1));

end

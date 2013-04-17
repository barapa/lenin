function [ features ] = get_model_activations_on_test_data( model, layers )

% no layers specified, use all of them
if nargin == 1
    layers = 1:model.nn.n;
end

% get testing data
[test_nn_x, song_borders, test_nn_y] = load_songs(model.test_nn_songs);

% whiten data
test_nn_x = whiten_data(test_nn_x, model.preprocessing_params.X_avg,...
    model.preprocessing_params.W);

% put data through network by calling predict
[labels, nn] = nnpredict(model.nn, test_nn_x');

% put together features
features = horzcat(nn.a{layers});

end


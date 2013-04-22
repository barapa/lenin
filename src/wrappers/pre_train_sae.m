function [ sae, sae_sizes, opt_preprocessing_params ] = pre_train_sae(...
  files_to_train,...
  network_params,...
  training_params,...
  opt_preprocessing_params )

fprintf('%s\n', 'Setting up SAE');

if exist('opt_preprocessing_params')
  fprintf('Generating whitening params...');
  [~, ~, ~, opt_preprocessing_params] = load_songs( files_to_train,...
    opt_preprocessing_params);
  fprintf(' ...done\n')
end

% get the first song to determine the size of the bottom layer
[song_data, ~, ~] = load_songs(files_to_train(1));

if exist('opt_preprocessing_params')
  fprintf('Whitening first song for SAE to determine network topology bottom layer...');
  song_data = whiten_data(song_data, opt_preprocessing_params.X_avg,...
    opt_preprocessing_params.W);
  fprintf('...done\n');
end

song_data = song_data'; % convert from DxN to NxD
[~, D] = size(song_data);

% setup sae by adding input layer to bottom of sizes
sae_sizes = [D network_params.sizes];
sae = saesetup(sae_sizes);

% for each layer, set up with the given params
num_layers = numel(sae_sizes) - 1;
for i = 1 : num_layers
  sae.ae{i}.activation_function = network_params.activation_function;
  sae.ae{i}.learningRate = training_params.learning_rate;
  sae.ae{i}.inputZeroMaskedFraction = training_params.input_zero_masked_fraction;
end

% set up the training params
opts.numepochs = training_params.num_epochs;
opts.batchsize = training_params.mini_batch_size;

% set up the song batch loop
num_songs = numel(files_to_train);
rand_song_order = randperm(num_songs);
num_song_batches = ceil(num_songs / training_params.song_batch_size);

fprintf('Beginning SAE training\n');

for b = 1 : num_song_batches
    fprintf('training song batch #%i of %i\n', b, num_song_batches);

    first_ind = (b - 1) * training_params.song_batch_size + 1;
    last_ind = min(b * training_params.song_batch_size, num_songs);

    disp('loading songs...') ;
    [ train_x, ~, ~ ] = load_songs(...
        files_to_train(rand_song_order(:, first_ind:last_ind))) ;
    disp('...done loading songs') ;

    if exist('opt_preprocessing_params')
    
      disp('whitening songs...') ;
      train_x = whiten_data(train_x, opt_preprocessing_params.X_avg,...
            opt_preprocessing_params.W);
      disp('...done') ;

    end

    train_x = train_x'; % convert from d x n to n x d matrix.

    disp('training SAE...');
    % train dbn on the current batch of song data
    sae = saetrain(sae, train_x, opts);
    disp('...done training SAE');

    if ~exist('DONT_VISUALIZE')
      figure;
      visualize(sae.ae{1}.W{1}(:,2:end)');
      title('SAE First layer weights or something weird!');
    end % if ~ exist('DONT_VISUALIZE')

end % for b = 1 : num_song_batches

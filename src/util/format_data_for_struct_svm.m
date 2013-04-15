% Formats data into a form that can be used by struct_hmm_{learn, classify}.
%
%    data - struct array with 'filename' char array, a d x n 'samples' vector
%           and a 1 x n 'labels' vector defined.
%    example_num - the unique number to use for this example.
%
% NOTE: labels will be changed by adding 1 to them, as struct SVM requires
%       labels in the range [1, \infty).
%
function [ data ] = format_data_for_struct_svm(data, example_num)

  samples = data.samples ;
  labels = data.labels ;
  name = data.filename ;
  data = {} ;

  for i = 1 : length(samples)

    if mod(i, 50) == 0
      disp(sprintf('song percent done: %f', (i / length(samples)))) ;
    end

    % we skip totally non-zero samples
    if sum(samples(:, i)) == 0
      continue ;
    end

    frame = write_frame(...
        samples(:, i), labels(:, i) + 1, name, example_num) ;

    data{i} = frame ;

  end % for i = 1 : length(samples)


function [ frame ] = write_frame(data, label, name, example_num)

  frame = sprintf('%d qid:%d ', label, example_num) ;

  num_features = length(data) ;

  for k = 1 : num_features

    % Note: we only need to record non-zero features.
    if data(k) == 0
      continue ;
    end

    frame = strcat(frame, sprintf(' %d:%f ', k, data(k))) ;

  end % for k = 1 : num_features

  frame = strcat(frame, sprintf(' # file: %s', name)) ;

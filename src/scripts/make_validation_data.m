% Dont use this script generally. It needs to be run from withn each run folder individually.
cd 90/;

% for 90, get the validation songs and truncate the training songs
labeled_train_filenames = load('./labeled_train_filenames.mat');
labeled_train_filenames = labeled_train_filenames.labeled_train_filenames;
validation_filenames = labeled_train_filenames(144:162);
labeled_train_filenames = labeled_train_filenames(1:143);

save('labeled_train_filenames', 'labeled_train_filenames');
save('validation_filenames', 'validation_filenames');

% now save the same validation sets for 30 and 60, but don't change anything else
cd ..
cd 60/
save('validation_filenames', 'validation_filenames');

cd ..
cd 30/
save('validation_filenames', 'validation_filenames');

cd ..

function [ ] = generate_chroma_song_files()
  CHROMA_DIR = 'data/chroma_raw/' ;
  LABEL_DIR = '/var/data/lenin/beatles/chordlabs/' ;
  OUT_DIR = 'data/chroma_formatted/' ;

  [ albums ] = dir(CHROMA_DIR) ;

  % skip '.' and '..'
  albums = albums(3 : end) ;

  for i = 1 : length(albums)
    album = albums(i).name ;

    % Different day, same bullshit.
    if strcmp(album, '.DS_Store')
      continue ;
    end

    album_dir = strcat(CHROMA_DIR, album) ;

    songs = dir(album_dir) ;

    % skip '.' and '..'
    songs = songs(3 : end) ;

    for j = 1 : length(songs)

      song_name = songs(j).name ;

      if strcmp(song_name, '.DS_Store')
        continue ;
      end

      disp(sprintf('Generating song %s...', song_name)) ;
      raw = load([album_dir, '/', song_name]) ;

      song = {} ;
      song.samples = raw.F ;
      song.filename = raw.ifname ;
      song.timestamps = raw.bts ;

      label_file = regexprep(song_name, 'mat', 'lab') ;
      label_filename = [ LABEL_DIR, album, '/', label_file ] ;
      disp(sprintf('Using label filename: %s...', label_filename)) ;
      song.labels = label_timestamps(song.timestamps, label_filename) ;

      save_filename = [ OUT_DIR, song_name ] ;
      save(save_filename, 'song') ;

    end % for j = 1 : length(songs)

  end % for i = 1 : length(albums)



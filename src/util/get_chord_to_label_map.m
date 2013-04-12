% Returns a chord to chord_label map.
%
%       Chord labels:
%              0 - 11: C ... B major
%             12 - 23: C ... B minor
%                  24: NO CHORD
%
function [ chord_to_label ] = get_chord_to_label_map

  chord_to_label = containers.Map
  chord_to_label('B#') = 0
  chord_to_label('C') = 0
  chord_to_label('C#') = 1
  chord_to_label('Db') = 1
  chord_to_label('D') = 2
  chord_to_label('D#') = 3
  chord_to_label('Eb') = 3
  chord_to_label('E') = 4
  chord_to_label('Fb') = 4
  chord_to_label('E#') = 5
  chord_to_label('F') = 5
  chord_to_label('F#') = 6
  chord_to_label('Gb') = 6
  chord_to_label('G') = 7
  chord_to_label('G#') = 8
  chord_to_label('Ab') = 8
  chord_to_label('A') = 9
  chord_to_label('A#') = 10
  chord_to_label('Bb') = 10
  chord_to_label('B') = 11
  chord_to_label('Cb') = 11
  chord_to_label('B#:min') = 12
  chord_to_label('C:min') = 12
  chord_to_label('C#:min') = 13
  chord_to_label('Db:min') = 13
  chord_to_label('D:min') = 14
  chord_to_label('D#:min') = 15
  chord_to_label('Eb:min') = 15
  chord_to_label('E:min') = 16
  chord_to_label('Fb:min') = 16
  chord_to_label('E#:min') = 17
  chord_to_label('F:min') = 17
  chord_to_label('F#:min') = 18
  chord_to_label('Gb:min') = 18
  chord_to_label('G:min') = 19
  chord_to_label('G#:min') = 20
  chord_to_label('Ab:min') = 20
  chord_to_label('A:min') = 21
  chord_to_label('A#:min') = 22
  chord_to_label('Bb:min') = 22
  chord_to_label('B:min') = 23
  chord_to_label('Cb:min') = 23
  chord_to_label('N') = 24

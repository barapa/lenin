% Return a chord_label to chord_number map.
%
%       LABEL KEY:
%              0 - 11: C ... B major
%             12 - 23: C ... B minor
%                  24: NO CHORD
%
function [ chord_to_key ] = chord_label_key

  chord_to_key = containers.Map
  chord_to_key('B#') = 0
  chord_to_key('C') = 0
  chord_to_key('C#') = 1
  chord_to_key('Db') = 1
  chord_to_key('D') = 2
  chord_to_key('D#') = 3
  chord_to_key('Eb') = 3
  chord_to_key('E') = 4
  chord_to_key('Fb') = 4
  chord_to_key('E#') = 5
  chord_to_key('F') = 5
  chord_to_key('F#') = 6
  chord_to_key('Gb') = 6
  chord_to_key('G') = 7
  chord_to_key('G#') = 8
  chord_to_key('Ab') = 8
  chord_to_key('A') = 9
  chord_to_key('A#') = 10
  chord_to_key('Bb') = 10
  chord_to_key('B') = 11
  chord_to_key('Cb') = 11
  chord_to_key('B#:min') = 12
  chord_to_key('C:min') = 12
  chord_to_key('C#:min') = 13
  chord_to_key('Db:min') = 13
  chord_to_key('D:min') = 14
  chord_to_key('D#:min') = 15
  chord_to_key('Eb:min') = 15
  chord_to_key('E:min') = 16
  chord_to_key('Fb:min') = 16
  chord_to_key('E#:min') = 17
  chord_to_key('F:min') = 17
  chord_to_key('F#:min') = 18
  chord_to_key('Gb:min') = 18
  chord_to_key('G:min') = 19
  chord_to_key('G#:min') = 20
  chord_to_key('Ab:min') = 20
  chord_to_key('A:min') = 21
  chord_to_key('A#:min') = 22
  chord_to_key('Bb:min') = 22
  chord_to_key('B:min') = 23
  chord_to_key('Cb:min') = 23
  chord_to_key('N') = 24

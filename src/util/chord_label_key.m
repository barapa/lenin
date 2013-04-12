% Return a chord_label to chord_number map.
%
%       LABEL KEY:
%              0 - 11: C ... B major
%             12 - 23: C ... B minor
%                  24: NO CHORD
%
function [ chord_to_key ] = chord_label_key

  chord_to_key = containers.Map
  chord_to_key('C') = 0
  chord_to_key('C#') = 1
  chord_to_key('Db') = 1
  chord_to_key('D') = 2
  chord_to_key('D#') = 3
  chord_to_key('Eb') = 3
  chord_to_key('E') = 4
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

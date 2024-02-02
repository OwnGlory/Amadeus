function TxtToMidi(filename)
    addpath(genpath('Materials\matlab-midi-master\src'))
    matrixData = load(filename);
    midi_new = matrix2midi(matrixData);
    writemidi(midi_new, 'Materials\testout.mid');
end


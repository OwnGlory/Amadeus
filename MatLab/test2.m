midiData = readmidi('Cymatics - All I Need - 165 BPM D# Min.mid',1);
midiInfoData = midiInfo(midiData);

matFilename = 'midi_info.mat';
save(matFilename, 'midiInfoData');

loadedData = load('midi_info.mat');
midiInfoData = loadedData.midiInfoData;
disp(midiInfoData);
% isequal(midi.rawbytes_all, writemidi(midi,'new.txt'));
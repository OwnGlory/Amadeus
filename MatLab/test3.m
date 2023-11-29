addpath('C:\Program Files\MATLAB\matlab-midi-master\src');
% Загружаем MIDI-файл
nmat = readmidi('Cymatics - Baby - 152 BPM A# Min.mid');

nmat = midiInfo(midiFile);
plotdist(pcdist1(nmat)) 

playsound(nmat);


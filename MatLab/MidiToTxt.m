%addpath(genpath('D:\Develop\Amadeus\matlab-midi-master\src'))

midiFile = readmidi('All_I_Need.mid');
midiData = midiInfo(midiFile);
disp(midiData);
% Указываем имя файла
filename = 'output.txt';
% Записываем матрицу в текстовый файл с разделителями (по умолчанию запятая)
writematrix(midiData, filename);
matrixData = load(filename);
midi_new = matrix2midi(midiData);
writemidi(midi_new, 'testout2.mid');
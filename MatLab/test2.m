addpath(genpath('D:\Develop\Amadeus\matlab-midi-master\src'))

mifiFile = readmidi('Cymatics - All I Need - 165 BPM D# Min.mid');

midiData = midiInfo(mifiFile);

disp(midiData);

% Указываем имя файла
filename = 'output3.txt';

% Записываем матрицу в текстовый файл с разделителями (по умолчанию запятая)
writematrix(midiData, filename);

matrixData = load(filename);

midi_new = matrix2midi(matrixData);

writemidi(midi_new, 'testout.mid');
addpath(genpath('Materials\matlab-midi-master\src'))
% Чтение MIDI файла
midiFile = readmidi('All_I_Need.mid');
% Получение информации из MIDI
midiData = midiInfo(midiFile);
% Вывод MIDI данных
% disp(midiData);
% Указываем имя файла
filename = 'Materials\output.txt';
% Записываем матрицу в текстовый файл с разделителями (по умолчанию запятая)
writematrix(midiData, filename);

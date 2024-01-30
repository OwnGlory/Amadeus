
[y,Fs] = audioread('./Wav/D#5 F#5 A#5 D#5.wav');
T = length(y)/Fs;
% y = mean(y, 2);
t = 0:1/Fs:T-1/Fs;
% figure();
% plot(t, y);
% title('Исходный сигнал');

[pks, locs] = findpeaks(y);

figure();
plot(t, y); % Построение графика сигнала
hold on;
plot(t(locs), pks, 'r*'); % Выделение пиков красными звездочками
hold off;
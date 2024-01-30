% Чтение аудиофайла
[stereoSignal, Fs] = audioread('D:\Develop\Amadeus\Materials\Wav\D#5 F#5 A#5 D#5.wav');

% Преобразование стерео в моно
monoSignal = sum(stereoSignal, 2) / size(stereoSignal, 2);

% Создание фильтра нижних частот
d = designfilt('lowpassfir', 'PassbandFrequency', 0.15, 'StopbandFrequency', 0.2, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'DesignMethod', 'kaiserwin');

% Применение фильтра к сигналу для устранения шума
filteredSignal = filtfilt(d, monoSignal);

% Усиление сигнала
gain = 1 / mean(abs(filteredSignal)); % Уровень усиления
amplifiedSignal = gain * filteredSignal;

% Преобразование Фурье
dft_signal = fft(amplifiedSignal);

% Определение частотного спектра
f = (0:length(dft_signal)-1)*Fs/length(dft_signal);

% Определение пиков в спектре
[pks, locs] = findpeaks(abs(dft_signal));

% Определение частот пиков
peak_freqs = f(locs);

% Определение нот
notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
note_freqs = 2 .^ ((-57:74)/12) * 440;
note_indices = round(log2(peak_freqs / 440) * 12) + 49;
note_indices(note_indices < 1 | note_indices > 12) = [];
detected_notes = notes(note_indices);

% Вывод результатов
for i = 1:length(detected_notes)
    fprintf('Note: %s, Frequency: %.2f Hz\n', detected_notes(i), peak_freqs(i));
end

% Построение графика частотного спектра
figure;
plot(f, abs(dft_signal));
hold on;

% Отметка пиков на графике
plot(peak_freqs, pks, 'ro');
hold off;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum with Peaks');
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

% Построение спектрограммы
window = hamming(1024);
noverlap = round(length(window)/2); % 50% overlap
nfft = 2048;
[S, F, T] = spectrogram(amplifiedSignal, window, noverlap, nfft, Fs, 'yaxis');

% Вычисление самых ярких значений
[maxValues, maxIndices] = max(abs(S), [], 1);
maxFrequencies = F(maxIndices);

% Вывод результатов
for i = 1:length(T)
    fprintf('At time %.2f s, the brightest frequency is %.2f Hz\n', T(i), maxFrequencies(i));
end

% Построение спектрограммы
spectrogram(amplifiedSignal, window, noverlap, nfft, Fs, 'yaxis');
title('Spectrogram of the Audio Signal');
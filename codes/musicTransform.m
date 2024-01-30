audioFilePath = 'D:\Develop\Amadeus\Materials\Wav\Аккордики потом ноты.wav';

[y, Fs]=audioread(audioFilePath);

% Преобразование Фурье
Y = fft(y);

% Получение спектра частот
P2 = abs(Y/length(y));
P1 = P2(1:length(y)/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Построение спектра
f = Fs*(0:(length(y)/2))/length(y);
plot(f,P1)

winLength = round(0.05*Fs);
overlapLength = round(0.045*Fs);
[f0, idx] = pitch(y, Fs, 'Method', 'SRH', 'WindowLength', winLength, 'OverlapLength', overlapLength);

% Определение пиков
[peaks, locations] = findpeaks(P1, 'MinPeakHeight', 0.1);
notes = f(locations);

% Определение длительности и амплитуды нот
noteDurations = diff(locations)/Fs;
noteAmplitudes = peaks(1:end-1);

%t = (0:length(y)-1)/Fs; % Создание вектора времени
%plot(t,y); % Построение графика
%xlabel('Время (с)'); % Подпись оси x
%ylabel('Амплитуда'); % Подпись оси y
%title('Аудиосигнал'); % Заголовок графика

%window = hamming(256); % Окно для анализа
%noverlap = 128; % Наложение окон
%nfft = 1024; % Размер FFT
%y = mean(y, 2);

% Создание спектрограммы
%figure;

%spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
%colorbar; % Добавление цветовой шкалы
%title('Спектрограмма сигнала без шума');
%plot(spectrogram);

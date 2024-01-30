[y, fs] = audioread('Wav\D#5 F#5 A#5 D#5.wav');

% Нормализация амплитуды
y = y / max(abs(y));

% Размер окна
windowSize = 1024; % Это значение можно изменить в соответствии с вашими потребностями

% Число перекрывающихся отсчетов
noverlap = round(windowSize/2); % Это значение можно изменить в соответствии с вашими потребностями

% Применение оконного преобразования Фурье
[S,F,T,P] = spectrogram(y,windowSize,noverlap,[],fs,'yaxis');

% Построение спектрограммы
figure;
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Время (с)'); ylabel('Частота (Hz)');
[y, Fs] = audioread('Wav\Аккордики потом ноты.wav');

% Создание сигнала
t = 0:1/Fs:(length(y)-1)/Fs; % Временной вектор

% Нормализация сигнала для каждого канала
y_norm = zeros(size(y));
for i = 1:size(y,2)
    y_norm(:,i) = (y(:,i) - min(y(:,i))) / (max(y(:,i)) - min(y(:,i)));
end

% Вывод графика для каждого канала
figure;
for i = 1:size(y,2)
    subplot(size(y,2),1,i);
    plot(t, y_norm(:,i));
    title(['Нормализованный сигнал канала ', num2str(i)]);
    xlabel('Время (с)');
    ylabel('Амплитуда');
end
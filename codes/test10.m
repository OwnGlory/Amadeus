[y, Fs] = audioread('Wav\Аккордики потом ноты.wav');

% Создание сигнала
t = 0:1/Fs:(length(y)-1)/Fs; % Временной вектор

% Нормализация сигнала
y_norm = (y - min(y)) / (max(y) - min(y));

% Разделение y_norm на 4 равные части
n = length(y_norm); % Получаем длину мелодии
partLength = floor(n/4); % Вычисляем длину каждой части

% Создаем 4 части в цикле
parts = cell(1, 4);
for i = 1:4
    parts{i} = y_norm((i-1)*partLength+1 : i*partLength);
end

% Вывод графика для каждой части
figure;
for i = 1:4
    subplot(4,1,i);
    plot(t(1:partLength), parts{i});
    title(['Часть ', num2str(i)]);
    xlabel('Время (с)');
    ylabel('Амплитуда');
end
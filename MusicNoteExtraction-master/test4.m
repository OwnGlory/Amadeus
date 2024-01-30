
% Загрузка аудиофайла
[audioIn, fs] = audioread('Wav\Аккордики и ноты одновременно.wav');

% Размер окна (в секундах)
windowSize = 0.1; % 100 мс
windowSamples = round(windowSize * fs);

% Количество окон
numWindows = floor(length(audioIn) / windowSamples);
% Инициализация массива для хранения всех частот
allFrequencies = cell(numWindows, 1);

% Цикл по окнам
for i = 1:numWindows
    % Выделение текущего окна
    window = audioIn((i-1)*windowSamples + 1 : i*windowSamples);
    
    % Преобразование Фурье
    n = length(window);
    y = fft(window);
    
    % Вычисление двустороннего спектра
    P2 = abs(y/n);
    
    % Вычисление одностороннего спектра
    P1 = P2(1:n/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    % Определение частотного диапазона
    f = fs*(0:(n/2))/n;
    
    % Нахождение всех пиков в спектре
    [pks, locs] = findpeaks(P1);
    
    % Сохранение всех частот пиков
    allFrequencies{i} = f(locs);
end

% Вывод всех частот для каждого окна
disp(allFrequencies);
% Загрузка аудиофайла
[audioIn, fs] = audioread('Wav/D#5 F#5 A#5 D#5.wav');
fs = fs*4;
% Предположим, что melody - это ваша мелодия
n = length(audioIn); % Получаем длину мелодии
duration = length(audioIn)/(fs/4);
maxFrequencies = [];
Freq = [];
Values = [];
partLength = floor(n/4); % Вычисляем длину каждой части

    % Размер окна (в секундах)
    windowSize = 0.1; % 100 мс
    windowSamples = round(windowSize * fs);
    numWindows = floor(length(audioIn) / windowSamples);
   
    % Цикл по окнам
    for k = 1:numWindows
        % Выделение текущего окна
        window = audioIn((k-1)*windowSamples + 1 : k*windowSamples);
    
        % Преобразование Фурье
        p = length(window);
        y = fft(window);
    
        % Вычисление двустороннего спектра
        P2 = abs(y/p);
    
        % Вычисление одностороннего спектра
        P1 = P2(1:p/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
    
        % Определение частотного диапазона
        f = fs*(0:(p/2))/p;
        
        [maxValue, indexMax] = max(P1);
        frequency = f(indexMax)/2;

        % Сохранение максимальной частоты
        Freq = [Freq; maxValue];
        Values = [Values; frequency];
       
    end
    disp(Freq)
    disp(Values)


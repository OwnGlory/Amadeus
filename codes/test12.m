% Загрузка аудиофайла
[audioIn, fs] = audioread('Wav/Аккордики потом ноты.wav');
fs = fs*4;
% Предположим, что melody - это ваша мелодия
n = length(audioIn); % Получаем длину мелодии
AudioDur = (n/(fs/4))/60;
partLength = floor(n/4); % Вычисляем длину каждой части
BPM = 0;
% Создаем 4 части в цикле
parts = cell(1, 4);
for i = 1:4
    startIdx = (i-1)*partLength + 1;
    endIdx = i*partLength;
    if i == 4
        endIdx = n; % Для последней части берем до конца мелодии
    end
    
    parts{i} = audioIn(startIdx:endIdx);

    % partdur = (length(parts{i})/(fs/4))/60;

    % Размер окна (в секундах)
    windowSize = 0.1; % 100 мс
    windowSamples = round(windowSize * fs);
    numWindows = floor(length(parts{i}) / windowSamples);
    maxFrequencies = [];
    highFrequencies = [];
   
    % Цикл по окнам
    for k = 1:numWindows
        % Выделение текущего окна
        window = parts{i}((k-1)*windowSamples + 1 : k*windowSamples);
    
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
        threshold = 0.028;
    
        % Нахождение пика с максимальной амплитудой
        
        [peaks, locations] = findpeaks(P1);
        highPeaks = peaks(peaks > threshold);
        proverka = f(locations(peaks > threshold));
        highFrequencies = [highFrequencies, f(locations(peaks > threshold))/2];

        [maxValue, indexMax] = max(P1);
        frequency = f(indexMax)/2;
        % Сохранение максимальной частоты
        maxFrequencies = [maxFrequencies, frequency];
    end
    
    % Получение уникальных элементов и их индексов
    [A_unique, ~, A_idx] = unique(highFrequencies, 'stable');
    [A_unique2, ~, A_idx2] = unique(maxFrequencies, 'stable');
    % Frequencies = A_unique;

    if length(highFrequencies) ~= 1
        highFrequencies(end) = [];
    end
    
    FreqNote = 1;
    if FreqNote ~= 0
        Freq = [];
        Notes = [];
        % Вывод максимальных частот для каждого окна
        for z = 1:length(A_unique)
            [note, frequency] = FreqToNote(A_unique(z));
            Freq = [Freq; frequency];
            Notes = [Notes; note];
        end
        % disp(Freq);
        % disp(Notes);
    end
    perem = length(A_unique2)
    BPM = BPM + perem
end

BPM = BPM/AudioDur;
% Загрузка аудиофайла
[audioIn, fs] = audioread("Hedwig's Theme.mp3");

n = length(audioIn); % Получаем длину мелодии
AudioDur = (n/fs);

%%  Нахождение нот. Первый проход.
% Размер окна (в секундах)
windowSize = 0.15; % сек.
windowSamples = round(windowSize * fs);
numWindows = floor(length(audioIn) / windowSamples);
threshold = 0.1;

maxFrequencies1 = [];
highFrequencies = [];

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


    [peaks, locations] = findpeaks(P1);
    highPeaks = peaks(peaks > threshold);
    if isempty(highPeaks)
        highPeaks = frequency;
    end
    if f(locations(peaks > threshold))/2 ~= 0
        proverka = f(locations(peaks > threshold))/2
    end
    highFrequencies = [highFrequencies, f(locations(peaks > threshold))/2];
    if isempty(highFrequencies)
        highFrequencies = [highFrequencies, frequency];
    end


    maxFrequencies1 = [maxFrequencies1; frequency];
    
end


%% Формирование единого массива нот.
maxFreq = [];
for i = 1:length(maxFrequencies1)
    if i <= length(maxFrequencies1)
        maxFreq = [maxFreq; maxFrequencies1(i)];
    end
end

counter = 0;
maxFreq_new = [];
Notes = [];
for i = 1:length(maxFreq)
    if i > 1
        if maxFreq(i-1) ~= maxFreq(i) && abs(maxFreq(i-1) - maxFreq(i)) > 2
            counter = counter + 1;
            maxFreq_new = [maxFreq_new; maxFreq(i-1)];
            if maxFreq_new(counter) ~= 0
                [note, frequency_new] = FreqToNote(maxFreq_new(counter));% Сохранение максимальной частоты
                Notes = [Notes; note];
            end
        end
    end
end


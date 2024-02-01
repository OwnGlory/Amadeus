% Загрузка аудиофайла
[audioIn, fs] = audioread('Wav/Аккордики и ноты одновременно.wav');

% Предположим, что melody - это ваша мелодия
n = length(audioIn); % Получаем длину мелодии
AudioDur = (n/(fs/4))/60;
duration = length(audioIn)/(fs);
partLength = floor(n/4); % Вычисляем длину каждой части


numStep = 0;
numPeaks = 0;
ChangeNote = 1;
startNoteDur = 0;
BPM = 0;
Counter = 0;
% fs = fs*4;


maxFrequencies = [];
Freq = [];
Values = [];
Note = [];
Velocity = [];
noteDurationArr = [];
StartNote = [];
StartNote = [StartNote, startNoteDur];


% Создаем 4 части в цикле
parts = cell(1, 4);
for i = 1:4
    startIdx = (i-1)*partLength + 1;
    endIdx = i*partLength;
    if i == 4
        endIdx = n; % Для последней части берем до конца мелодии
    end
    
    parts{i} = audioIn(startIdx:endIdx);
    %%  Нахождение нот 
    % Размер окна (в секундах)
    fs = fs*4;
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
        
        [maxValue, indexMax] = max(P1);
        frequency = f(indexMax)/2;
    
        % Нахождение пика с максимальной амплитудой
        
        [peaks, locations] = findpeaks(P1);
        highPeaks = peaks(peaks > threshold);
        if isempty(highPeaks)
            highPeaks = frequency;
        end
        proverka = f(locations(peaks > threshold));
        highFrequencies = [highFrequencies, f(locations(peaks > threshold))/2];
        if isempty(highFrequencies)
             highFrequencies = [highFrequencies, frequency];
        end

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
        NewFreq = [];
        Notes = [];
        % Вывод максимальных частот для каждого окна
        for z = 1:length(A_unique)
            [note, frequency] = FreqToNote(A_unique(z));
            NewFreq = [NewFreq; frequency];
            Notes = [Notes; note];
        end
        % disp(NewFreq);
        disp(Notes);

    end
    perem = length(A_unique2);
    BPM = BPM + perem;

    %% Нахождение параметров для записи в MIDI
    fs = fs/4;
    % Размер окна (в секундах)
    windowSize = 0.1; % 100 мс
    windowSamples = round(windowSize * fs);
    numWindows = floor(length(parts{i}) / windowSamples);
    % Цикл по окнам
    for k = 1:numWindows
        Counter = Counter + 1;
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
        
        [maxValue, indexMax] = max(P1);
        frequency = f(indexMax)/2;

        % Сохранение максимальной частоты
        Freq = [Freq; frequency];   
        Values = [Values; maxValue];
        if ~isempty(Freq) && Counter > 1
            if Counter == numWindows
                numPeaks = Counter - numStep;
                noteDuration = numPeaks * 0.1;
                startNoteDur = startNoteDur + noteDuration;
                noteDurationArr = [noteDurationArr, noteDuration];
                StartNote = [StartNote, startNoteDur];
            end

            if Freq(Counter) ~= Freq(Counter-1)
                new_Counter = Counter - 1;
                numPeaks = new_Counter - numStep;
                numStep = new_Counter;
                noteDuration = numPeaks * 0.1;
                ChangeNote = 1;
                startNoteDur = startNoteDur + noteDuration;
                noteDurationArr = [noteDurationArr, noteDuration];
                StartNote = [StartNote, startNoteDur];
            end

            if Freq(Counter) == Freq(Counter-1)
                if ChangeNote == 1
                    if Values(Counter) > Values(Counter-1)
                        maxAmp = Values(Counter);
                    else
                        maxAmp = Values(Counter-1);
                    end
                    vel = (sqrt(maxAmp) * 127)*7; % !!! Не точное определение амплитуды !!!
                    if vel > 127
                        vel = 127;
                    end
                    Velocity = [Velocity, round(vel)];
                    NoteNum = round(12 * log2((frequency*4) / 440) + 69)
                    Note = [Note, NoteNum];
                    [note, frequency] = FreqToNote(frequency);
                    if ismember(frequency*4, round(NewFreq))
                        for z = 1:length(NewFreq)
                            if round(NewFreq(z)) ~= round(frequency*4)
                                NoteNum = round(12 * log2((NewFreq(z)) / 440) + 69)
                                Note = [Note, NoteNum];
                                StartNote = [StartNote, startNoteDur];
                                Velocity = [Velocity, round(vel)];
                            end
                        end
                    end
                    ChangeNote = 0;
                else
                    if Values(Counter) > maxAmp
                        new_Counter = Counter - 1;
                        numPeaks = new_Counter - numStep;
                        numStep = new_Counter;
                        noteDuration = numPeaks * 0.1;
                        startNoteDur = startNoteDur + noteDuration;
                        noteDurationArr = [noteDurationArr, noteDuration];
                        StartNote = [StartNote, startNoteDur];
                    end
                end
            end
        end
        FiveCol = StartNote(1:end-1);
        SixCol = StartNote(2:end);
    end
end

BPM = BPM/AudioDur;
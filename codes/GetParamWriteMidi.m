function [outputArg1,outputArg2] = GetParamWriteMidi(inputArg1,inputArg2)
% Загрузка аудиофайла
[audioIn, fs] = audioread('Wav/D#5 F#5 A#5 D#5.wav');
% fs = fs;
% Предположим, что melody - это ваша мелодия
n = length(audioIn); % Получаем длину мелодии
duration = length(audioIn)/(fs);
maxFrequencies = [];
Freq = [];
Values = [];
Note = [];
Velocity = [];
numStep = 0;
numPeaks = 0;
noteDurationArr = [];
ChangeNote = 1;
startNoteDur = 0;
StartNote = [];
StartNote = [StartNote, startNoteDur];
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
        Freq = [Freq; frequency];   
        Values = [Values; maxValue];
        if ~isempty(Freq) && k > 1
            if k == numWindows
                numPeaks = k - numStep;
                noteDuration = numPeaks * 0.1;
                startNoteDur = startNoteDur + noteDuration;
                noteDurationArr = [noteDurationArr, noteDuration];
                StartNote = [StartNote, startNoteDur];
            end

            if Freq(k) ~= Freq(k-1)
                new_k = k - 1;
                numPeaks = new_k - numStep;
                numStep = new_k;
                noteDuration = numPeaks * 0.1;
                ChangeNote = 1;
                startNoteDur = startNoteDur + noteDuration;
                noteDurationArr = [noteDurationArr, noteDuration];
                StartNote = [StartNote, startNoteDur];
            end

            if Freq(k) == Freq(k-1)
                if ChangeNote == 1
                    if Values(k) > Values(k-1)
                        maxAmp = Values(k);
                    else
                        maxAmp = Values(k-1);
                    end
                    vel = (sqrt(maxAmp) * 127)*7; % !!! Не точное определение амплитуды !!!
                    if vel > 127
                        vel = 127;
                    end
                    Velocity = [Velocity, round(vel)];
                    NoteNum = round(12 * log2((frequency*4) / 440) + 49)
                    Note = [Note, NoteNum];
                    ChangeNote = 0;
                else
                    if Values(k) > maxAmp
                        new_k = k - 1;
                        numPeaks = new_k - numStep;
                        numStep = new_k;
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
    disp(Freq)
    disp(noteDurationArr)
    disp(Values)
    disp(StartNote)

 
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end


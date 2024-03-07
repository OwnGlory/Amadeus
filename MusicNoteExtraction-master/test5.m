% Загрузка аудиофайла
[audioIn, fs] = audioread("Hallelujah.mp3");
filename = 'Materials\output44.txt';
n = length(audioIn); % Получаем длину мелодии
AudioDur = (n/fs);
NoteDur = 0.5; % сек
startNoteDur = 0;
noteDurationArr = [];
StartNote = [];
StartNote = [StartNote; startNoteDur];
Velocity = [];
NoteNumArr = [];
BPM = 0;
ChangeNote = 1;

%%  Нахождение нот. Первый проход.
% Размер окна (в секундах)
windowSize = 0.4; % сек.
windowSamples = round(windowSize * fs);
numWindows = floor(length(audioIn) / windowSamples);

maxFrequencies1 = [];
Freq1 = [];
Values1 = [];

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
    frequency = f(indexMax);

    Freq1 = [Freq1; frequency];   
    Values1 = [Values1; round(maxValue, 4)];

    maxFrequencies1 = [maxFrequencies1; frequency];
    
end

%%  Нахождение нот. Второй проход.
offset = round(windowSize * fs / 3); % Смещение на треть окна
numWindows = floor((length(audioIn) - offset) / windowSamples);

maxFrequencies2 = [];
Freq2 = [];
Values2 = [];

% Цикл по окнам
for k = 1:numWindows
    % Выделение текущего окна
    window = audioIn(offset + (k-1)*windowSamples + 1 : offset + k*windowSamples);

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
    frequency = f(indexMax);

    Freq2 = [Freq2; frequency];   
    Values2 = [Values2; round(maxValue, 4)];

    % Сохранение максимальной частоты
    maxFrequencies2 = [maxFrequencies2; frequency];

end

%%  Нахождение нот. Третий проход.
offset = round(2 * windowSize * fs / 3); % Смещение на две трети окна
numWindows = floor((length(audioIn) - offset) / windowSamples);

maxFrequencies3 = [];
Freq3 = [];
Values3 = [];

% Цикл по окнам
for k = 1:numWindows
    % Выделение текущего окна
    window = audioIn(offset + (k-1)*windowSamples + 1 : offset + k*windowSamples);
    
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
    frequency = f(indexMax);

    Freq3 = [Freq3; frequency];   
    Values3 = [Values3; round(maxValue, 4)];

    % Сохранение макsсимальной частоты
    maxFrequencies3 = [maxFrequencies3; frequency];
end

%% Формирование единого массива нот.




maxFreq = [];
UniteValue = [];

for i = 1:length(maxFrequencies1)
    if i <= length(maxFrequencies1)
        maxFreq = [maxFreq; maxFrequencies1(i)];
        UniteValue = [UniteValue; Values1(i)];
    end
    if i <= length(maxFrequencies2)
        maxFreq = [maxFreq; maxFrequencies2(i)];
        UniteValue = [UniteValue; Values2(i)];
    end
    if i <= length(maxFrequencies3)
        maxFreq = [maxFreq; maxFrequencies3(i)];
        UniteValue = [UniteValue; Values3(i)];
    end
end

counter = 0;
maxFreq_new = [];
Notes_new = [];
for i = 1:length(maxFreq)
    if i > 1
        if maxFreq(i-1) ~= maxFreq(i) && abs(maxFreq(i-1) - maxFreq(i)) > 2 && maxFreq(i-1) ~= 0 && maxFreq(i-1) > 15
            counter = counter + 1;
                maxFreq_new = [maxFreq_new; maxFreq(i-1)];
                [note, frequency_new] = FreqToNote(maxFreq_new(counter));% Сохранение максимальной частоты
                Notes_new = [Notes_new, note];
                startNoteDur = startNoteDur + NoteDur;
                StartNote = [StartNote, startNoteDur];
                Velocity = [Velocity, 71];
        end
    end
end
Notes = [];
maxAmp = [];
maxAmp = [maxAmp, 0];
Freq = [];
Freq = [Freq, 0];
avg = 0;

for i = 1:length(maxFreq)-1
    if ~isempty(maxFreq) && maxFreq(i) > 15 && maxFreq(i) ~= 0
            if maxFreq(i) == maxFreq(i+1) || abs(maxFreq(i) - maxFreq(i+1)) < 4
                maxAmp = [maxAmp, UniteValue(i)];
                Freq = [Freq, maxFreq(i)];
            else
                maxAmp = [maxAmp, UniteValue(i)];
                Freq = [Freq, maxFreq(i)];

                if mod(length(maxAmp), 2) == 0
                    maxAmp = [maxAmp, 0];
                else
                    maxAmp = [maxAmp, 0];
                    maxAmp = [maxAmp, 0];
                end
                
                for k = 1:length(maxAmp)
                    avg = avg + maxAmp(k);
                end
                avg = round((avg/(length(maxAmp)-1)), 5);
                for k = 1:length(maxAmp)
                    if maxAmp(k) ~= maxAmp(k+1) && k ~= 0
                        if maxAmp(k-1) < maxAmp(k) > maxAmp(k+1)
                            NoteNum = round(12 * log2((Freq(k)) / 440) + 69);
                            NoteNumArr = [NoteNumArr, NoteNum];
                            [note, frequency_new] = FreqToNote(Freq(k));
                            Notes = [Notes, note];
                        end
                    end
                end
                maxAmp = [];
                maxAmp = [maxAmp, 0];
                Freq = [];
                Freq = [Freq, 0];
                avg = 0;
            end
    end
end




BPM = BPM + length(maxFreq_new);
BPM = BPM/AudioDur;

FiveCol = StartNote(1:end-1);
SixCol = StartNote(2:end);

%% Запись в midi
% WriteMidiFromArr(filename, NoteNumArr, Velocity, FiveCol, SixCol);
% TxtToMidi(filename);
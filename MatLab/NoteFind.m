%% Загрузка аудиофайла

filename_melody = "E:\Develop\Amadeus\MusicNoteExtraction-master\FEBeethoven.mp3";
filename_txt = 'E:\Develop\Amadeus\Materials\output84.txt';

[audioIn, fs] = audioread(filename_melody);


%% Получение темпа мелодии.

BPM = pyrunfile("BPM.py", "bpm", audio_file=filename_melody);
BPM = round(BPM);


%% Получение длительности нот.

quantity_quarter_in_melody = BPM / 60;
quarter = round(1 / quantity_quarter_in_melody, 2);
whole =  round(quarter * 4, 2);
half = round(quarter * 2, 2);
eighth = round(quarter / 2, 2);
sixteenth = round(quarter / 4, 2);

quarter_half = quarter / 2;
whole_half = whole / 2;
half_half = half / 2;
eighth_half = eighth / 2;
sixteenth_half = sixteenth / 2;


%% Определение переменных и их значений.

n = length(audioIn); % Получаем длину мелодии
AudioDur = (n/fs);
NoteDur = 0.5; % сек
startNoteDur = 0;
quantity_windows = 0;
note_peak = 0;

noteDurationArr = [];
StartNote = [];
StartNote = [StartNote; startNoteDur];
Velocity = [];
NoteNumArr = [];


%%  Нахождение нот. Первый проход.
% Размер окна (в секундах)
windowSize = 0.18; % сек.
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

Notes = [];
maxAmp = [];
maxAmp = [maxAmp, 0];
Freq = [];
Freq = [Freq, 0];
avg = 0;
value = 0;

for i = 1:length(maxFreq)-1
    if ~isempty(maxFreq) && maxFreq(i) > 15 && maxFreq(i) ~= 0
            if maxFreq(i) == maxFreq(i+1) || abs(maxFreq(i) - maxFreq(i+1)) < 11
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
                    if maxAmp(k) ~= 0
                        quantity_windows = quantity_windows + 1;
                        if maxAmp(k) >= 0.001
                            if maxAmp(k) ~= maxAmp(k+1)
                                if (maxAmp(k-1) < maxAmp(k)) && (maxAmp(k) > maxAmp(k+1))
                                    NoteNum = round(12 * log2((Freq(k)) / 440) + 69);
                                    NoteNumArr = [NoteNumArr, NoteNum];
                                    [note, frequency_new] = FreqToNote(Freq(k));
                                    Notes = [Notes, note];
                                    Velocity = [Velocity, 71];
                                    note_peak = 1;
                                end
                            else
                                if (maxAmp(k-1) < maxAmp(k)) && (maxAmp(k) > maxAmp(k+2))
                                    NoteNum = round(12 * log2((Freq(k)) / 440) + 69);
                                    NoteNumArr = [NoteNumArr, NoteNum];
                                    [note, frequency_new] = FreqToNote(Freq(k));
                                    Notes = [Notes, note];
                                    Velocity = [Velocity, 71];
                                    note_peak = 1;
                                end
                            end
                        end

                        if quantity_windows
                            if (maxAmp(k) < maxAmp(k+1) || maxAmp(k+1) == 0 || maxAmp(k) < maxAmp(k+2)) && note_peak == 1 
                                duration = DefinitionDuration(quantity_windows, windowSize, eighth, eighth_half, sixteenth, sixteenth_half, ...
    quarter, quarter_half, half, whole);
                                startNoteDur = startNoteDur + duration;
                                StartNote = [StartNote, startNoteDur];
                                note_peak = 0;
                                quantity_windows = 0;
                            end
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

FiveCol = StartNote(1:end-1);
SixCol = StartNote(2:end);


%% Запись в midi

WriteMidiFromArr(filename_txt, NoteNumArr, Velocity, FiveCol, SixCol);
TxtToMidi(filename_txt);


%% Функция определения длительности отдельной ноты.

function duration = DefinitionDuration(quantity_windows, windowSize, eighth, eighth_half, sixteenth, sixteenth_half, ...
    quarter, quarter_half, half, whole)
    noteWinDur = windowSize + ((windowSize / 3) * (quantity_windows - 1));
    if noteWinDur < (eighth - sixteenth_half)
        duration = sixteenth;
    end 
    if noteWinDur >= (sixteenth + sixteenth_half) && noteWinDur < quarter
        duration = eighth;
    end
    if noteWinDur >= (eighth + sixteenth_half) && noteWinDur < half
        duration = quarter;
    end
    if noteWinDur >= (quarter + eighth_half) && noteWinDur < whole
        duration = half;
    end
    if noteWinDur >= (half + quarter_half)
        duration = whole;
    end   
end

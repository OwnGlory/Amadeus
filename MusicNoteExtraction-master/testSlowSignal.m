% Чтение аудиофайла
[audioIn, Fs] = audioread('Wav/Аккордики и ноты одновременно.wav');

% Предположим, что melody - это ваша мелодия, а Fs - это ее частота дискретизации
P = 2; % Фактор увеличения числа отсчетов
Q = 1; % Фактор уменьшения числа отсчетов

% audioOut = stretchAudio(audioIn,0.25);
audioOut = resample(audioIn, P, Q);
% Fs = Fs*2;
audiowrite('output.wav', audioOut, Fs);

% Предположим, что melody - это ваша мелодия
n = length(audioIn); % Получаем длину мелодии
partLength = floor(n/4); % Вычисляем длину каждой части

% Создаем 4 части в цикле
parts = cell(1, 4);
for i = 1:4
    startIdx = (i-1)*partLength + 1;
    endIdx = i*partLength;
    if i == 4
        endIdx = n; % Для последней части берем до конца мелодии
    end
    
    parts{i} = audioIn(startIdx:endIdx);


    % Используем функцию resample для изменения темпа мелодии
    % parts{i} = resample(parts{i}, P, Q); % Замедляем мелодию в два раза
    % Fs_new = Fs*4;
end
% Записываем каждую часть в отдельный файл
for i = 1:4
    filename = sprintf('part%d.wav', i);
    audiowrite(['SignalPart' num2str(i) '.wav'], parts{i}, Fs); % Предполагаем, что Fs - это частота дискретизации
end


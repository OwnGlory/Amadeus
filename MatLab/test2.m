
fs = 44100;
noteNumber = 69;
duration = 2;

value = generatePianoWave(noteNumber, duration, fs);

function pianoSound = generatePianoWave(noteNumber, duration, fs)
    % noteNumber - номер ноты (например, 69 для A4)
    % duration - продолжительность звучания ноты в секундах
    % fs - частота дискретизации

    % Перевод номера ноты в частоту
    frequency = 440 * 2^((noteNumber - 69) / 12);

    % Создание временного вектора
    t = linspace(0, duration, round(fs * duration));

    % Генерация синусоидальной волны
    waveform = sin(2 * pi * frequency * t);
    disp(size(waveform));
    % Атака (квадратичная)
    attack = (linspace(0, 1, round(fs * 0.2))).^2;
    % attack = attack(1:length(waveform));
    waveform(1:length(attack)) = waveform(1:length(attack)) .* attack;
    disp(size(waveform));

    % Удержание
    sustain = ones(1, round(fs * 0.6));
    % sustain = sustain(1:length(waveform)); 

    % Затухание (квадратичное)
    decay = (linspace(1, 0.5, round(fs * 0.6))).^2;
    % decay = decay(1:length(waveform));
    release = linspace(0.5, 0, round(fs * 0.6));
    % release = release(1:length(waveform));

    % envelope = [sustain; decay; release];

    envelope = [attack, sustain, decay, release];

    disp(size(waveform));
    disp(size(envelope));

    waveform = waveform .* envelope;

    % Добавление гармоник для более богатого звучания
    harmonic2 = 0.3 * sin(2 * pi * 2 * frequency * t);
    harmonic3 = 0.2 * sin(2 * pi * 3 * frequency * t);
    waveform = waveform + harmonic2 + harmonic3;

    % Нормализация амплитуды
    waveform = waveform / max(abs(waveform));

    % Возврат звуковой волны
    pianoSound = waveform;

    % Сохранение аудиофайла (если нужно)
    audiowrite('piano_A4_upgraded.wav', pianoSound, fs);
end
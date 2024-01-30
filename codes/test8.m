% Configuration
FPS = 30;
FFT_WINDOW_SECONDS = 0.25; % how many seconds of audio make up an FFT window

% Note range to display
FREQ_MIN = 10;
FREQ_MAX = 1000;

% Notes to display
TOP_NOTES = 3;

% Names of the notes
NOTE_NAMES = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};

% Output size. Generally use SCALE for higher res, unless you need a non-standard aspect ratio.
RESOLUTION = [1920, 1080];
SCALE = 2; % 0.5=QHD(960x540), 1=HD(1920x1080), 2=4K(3840x2160);

% Load necessary libraries
% addpath('path_to_matlab_fftpack_library'); % Add the path to the fftpack library in Matlab

% Get a WAV file from GDrive, such as:
% AUDIO_FILE = fullfile(PATH, 'short_popcorn.wav');

% Or download my sample audio
websave('D:\Develop\Amadeus\Materials\piano_c_major_scale.wav', 'https://github.com/jeffheaton/present/raw/master/youtube/video/sample_audio/piano_c_major_scale.wav');
AUDIO_FILE = 'D:\Develop\Amadeus\Materials\piano_c_major_scale.wav';

[data, fs] = audioread(AUDIO_FILE); % load the data
audio = data(:, 1); % this is a two channel soundtrack, get the first track
FRAME_STEP = (fs / FPS); % audio samples per video frame
FFT_WINDOW_SIZE = fs * FFT_WINDOW_SECONDS;
AUDIO_LENGTH = length(audio) / fs;

% Определение окна Ханна
window = 0.5 * (1 - cos(linspace(0, 2*pi, FFT_WINDOW_SIZE)));

% Рассчитываем частоты исходного сигнала
xf = linspace(fs/2, FFT_WINDOW_SIZE/2 + 1);
FRAME_COUNT = round(AUDIO_LENGTH * FPS);
FRAME_OFFSET = round(length(audio) / FRAME_COUNT);

% Первый проход, находим максимальную амплитуду для масштабирования
mx = 0;
for frame_number = 1:FRAME_COUNT
    sample = extract_sample(audio, frame_number);

    fftr = fft(sample .* window);
    fftr = abs(fftr);
    mx = max(max(fftr), mx);
end

fprintf('Max amplitude: %f\n', mx);

% Второй проход, создаем анимацию
for frame_number = 1:FRAME_COUNT
    sample = extract_sample(audio, frame_number);
    notes = [];
    fftr = fft(sample .* window);
    fftr = abs(fftr) / mx;
    
    % Найти верхние ноты (предположительно ваши функции find_top_notes и plot_fft)
    s = find_top_notes(fftr, TOP_NOTES, xf);
    disp(s)

    % Ваша функция plot_fft
    % plot_fft(fftr, xf, fs, s, RESOLUTION);
    
    % Сохраняем изображение
    % frame_filename = sprintf('D:\Develop\Amadeus\Materials\frame%d.png', frame_number);
    % saveas(gcf, frame_filename, 'png');
end

function fig = plot_fft(p, xf, fs, notes, dimensions)
    % Plot the frequency spectrum
    % Inputs:
    %   p: Magnitude of the FFT
    %   xf: Frequency values
    %   fs: Sampling frequency
    %   notes: Array of notes
    %   dimensions: Dimensions of the plot (optional)
    % Output:
    %   fig: MATLAB figure object

    FREQ_MIN = 0; % Define FREQ_MIN
    FREQ_MAX = fs/2; % Define FREQ_MAX

    layout = struct(...
        'title', "frequency spectrum", ...
        'autosize', false, ...
        'width', dimensions(1), ...
        'height', dimensions(2), ...
        'xaxis_title', "Frequency (note)", ...
        'yaxis_title', "Magnitude", ...
        'font', struct('size', 24) ...
    );

    fig = figure('Position', [100, 100, dimensions(1), dimensions(2)]);

    plot(xf, p);
    title("frequency spectrum");
    xlabel("Frequency (note)");
    ylabel("Magnitude");

    for i = 1:length(notes)
        note = notes(i);
        text(note(1)+10, note(3), note(2), 'FontSize', 48);
    end
end

function sample = extract_sample(audio, frame_number)
    % Extract a sample from the audio
    % Inputs:
    %   audio: Audio signal
    %   frame_number: Frame number
    % Output:
    %   sample: Extracted sample

    FRAME_OFFSET = 1; % Define FRAME_OFFSET
    FFT_WINDOW_SIZE = 512; % Define FFT_WINDOW_SIZE

    end_index = frame_number * FRAME_OFFSET;
    begin_index = int32(end_index - FFT_WINDOW_SIZE);

    if end_index == 0
        sample = zeros(abs(begin_index), 1);
    elseif begin_index < 0
        sample = [zeros(abs(begin_index), 1); audio(1:end_index)];
    else
        sample = audio(begin_index:end_index);
    end
end

function found = find_top_notes(fftr, num, xf)
    if max(fftr) < 0.001
        found = [];
    else
        % Создание массива, содержащего пары (индекс, значение) для fft.real
        lst = [(1:length(real(fftr)))', real(fftr)];
        lst = sortrows(lst, -2);

        % Инициализация переменных
        idx = 1;
        found = [];
        found_note = containers.Map;

        while idx <= length(lst) && length(found) < num
            element = lst(idx, 1);
            f = xf(element);
            y = lst(idx, 2);
            n = freq_to_number(f);
            n0 = round(n);
            name = note_name(n0);
            disp(name)

            if ~isKey(found_note, name)
                found_note(name) = true;
                s = [f, name, y];
                found = [found; s];
            end
            idx = idx + 1;
        end
    end
end

function n = freq_to_number(f)
    n = round(49 + 12 * log2(f/440.0));
end

function f = number_to_freq(n)
    f = 440 * 2.0.^((n-49)/12.0);
end

function name = note_name(n)
    NOTE_NAMES = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};
    name = [NOTE_NAMES{mod(n, 12) + 1}, num2str(round(n/12 - 1))];
end


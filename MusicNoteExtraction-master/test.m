%% set up song
clear; clc; clf; close all

mute = true; % set this to false to hear audio throughout program
             % useful for debugging

[song,Fs] = audioread('FurElise_Slow.mp3'); % Исходная мелодия
Fs = Fs*4; % Новая частота дискретизации
% song = resample(song, Fs_new, Fs);
figure, plot(song(:,1)), title('Fur Elise, entire song')

%% set parameters (change based on song)
n = length(song);
parts = 4; % number of parts to divide the song into
part_length = floor(n/parts);

for part = 1:parts
    t1 = (part-1)*part_length + 1;
    t2 = part*part_length;

    % analyze a window of the song
    y = song(t1:t2);
    [~,n] = size(y);
    t = linspace(t1,t2,n);
    if ~mute, plotsound(y,Fs); end
    audiowrite(['fur_elise_window_part' num2str(part) '.wav'],y,Fs);

    %% downsample by m
    clc
    m = 20;
    Fsm = round(Fs/m);
    p = floor(n/m);
    y_avg = zeros(1,p);
    for i = 1:p
        y_avg(i) = mean(y(m*(i-1)+1:m*i));
    end
    % figure, plot(linspace(0,100,n),abs(y)), hold on
            % plot(linspace(0,100,p),abs(y_avg))
            % title(['Discrete notes of song, part ' num2str(part)])
            % legend('Original', '20-point averaged and down-sampled')
    if ~mute, sound(y_avg,Fsm); end

    %% threshold to find notes
    close all
    y_thresh = zeros(1,p);
    i = 1;
    while (i <= p)
        thresh = 5*median(abs(y_avg(max(1,i-5000):i)));
        if (abs(y_avg(i)) > thresh)
            for j = 0:500
                if (i + j <= p)
                    y_thresh(i) = y_avg(i);
                    i = i + 1;
                end
            end
            i = i + 1400;
        end
        i = i + 1;
    end

    % figure, subplot(2,1,1), plot(abs(y_avg)), title(['Original song, part ' num2str(part)]), ylim([0 1.1*max(y_avg)])
            % subplot(2,1,2), plot(abs(y_thresh)), title('Detected notes using moving threshold')

    if ~mute, sound(y_thresh,round(Fsm)); end

    %% find frequencies of each note
    clc; close all

    i = 1;
    i_note = 0;
    while i < p
        j = 1;
        end_note = 0;
        while (((y_thresh(i) ~= 0) || (end_note > 0)) && (i < p))
            note(j) = y_thresh(i);
            i = i + 1;
            j = j + 1;
            if (y_thresh(i) ~= 0)
                end_note = 20;
            else
                end_note = end_note - 1;
            end
            if (end_note == 0)
               if (j > 25)
                   note_padded = [note zeros(1,j)]; % pad note with zeros to double size (N --> 2*N-1)
                   Note = fft(note_padded);
                   Ns = length(note);
                   f = linspace(0,(1+Ns/2),Ns);
                   [~,index] = max(abs(Note(1:length(f))));
                   if (f(index) > 20)
                       i_note = i_note + 1;
                       fundamentals(i_note) = f(index)*2;
                       figure, plot(f,abs(Note(1:length(f))))
                               title(['Fundamental frequency = ',num2str(fundamentals(i_note)),' Hz'])
                               plot(note_padded)
                   end
                   i = i + 50;
               end
               clear note;
               break
            end

        end
        i = i + 1;
    end

    %% play back notes
    amp = 0.5;
    fs = 44100;  % sampling frequency
    duration = 1;
    wave_arr = zeros(1, part_length);
    for i = 1:length(fundamentals)
        [letter(i,1),freq(i)]= FreqToNote(fundamentals(i));
        values = 0:1/fs:duration;
        a = wavefunction(fs, freq(i), duration, amp);
        recreate_song((i-1)*fs*duration+1:i*fs*duration+1) =+ a;
        if ~mute, sound(a,fs); pause(.5); end
    end
    letter
    audiowrite(['fur_elise_recreated_part' num2str(part) '.wav'],recreate_song,fs);
end


function wave = wavefunction(samplefreq, freq, time, amplitude)
    constant_exp = -0.0015;
    n = 5;
    T = (0:1/samplefreq:time);
    wave = zeros(size(T));
    number_sin = 2 .* pi .* freq;
    number_exp = constant_exp .* number_sin;
    
    for j = 1:n
        wave = wave + amplitude .* sin(j .* number_sin .* T) .* exp(number_exp .* T) ./ 2^(j-1);
    end
    
    wave = (wave + wave.^(4));
end

notes = [27;51;54];
amplitude = [0.5827;0.4016;0.4016];
duration = 1.7143;

wave = wavefunction(44100, notes, duration, amplitude);



% Применение быстрого преобразования Фурье (FFT)
fft_result = fft(wave);

% Вычисление частот и амплитуд для построения графика
samplefreq = 44100;
frequencies = (0:1/(duration*samplefreq):(1/(2*duration))-1/(duration*samplefreq));
amplitude_spectrum = abs(fft_result(1:length(frequencies)));

% Построение графика
figure;

% Подграфик для временного сигнала
subplot(2, 1, 1);
plot((0:length(wave)-1)/samplefreq, wave);
title('График временного сигнала');
xlabel('Время (сек)');
ylabel('Амплитуда');
grid on;

% Подграфик для частотного спектра
subplot(2, 1, 2);
plot(frequencies, amplitude_spectrum);
title('График частотного спектра');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;

function wave = wavefunction(samplefreq, note, time, amplitude)
    constant_exp = -0.0015;
    n = 6;
    T = (0:1/samplefreq:time);
    wave = zeros(size(T));
    freq = 440 * 2.^((note-49)/12);
    number_sin = 2 * pi * freq;
    number_exp = constant_exp * number_sin;
    
    for j = 1:n
        wave = wave + amplitude .* sin(j .* number_sin .* T) .* exp(number_exp .* T) ./ 2^(j-1);
    end
    
    wave = (wave + wave.^(4));
    % wave = wave .* 1 + 16 .* T .* exp(-6 .* T);
end
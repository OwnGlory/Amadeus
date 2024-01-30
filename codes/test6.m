[x, fs] = audioread('D:\Develop\Amadeus\Materials\output.wav');

% Анализ частотного спектра
N = length(x);
fft_result = fft(x);
frequencies = linspace(0, fs, N);

% Преобразование вещественной и мнимой части в амплитуду
amplitude = abs(fft_result);

% Использование только половины амплитудного спектра (избегаем дублирования)
half_amplitude = amplitude(1:N/2);

[peaks, peak_indices] = findpeaks(half_amplitude);

noteNumbers = round(69 + 12 * log2(frequencies(peak_indices)/440));

% Построение графика
figure;
subplot(2, 1, 1);
plot(frequencies, amplitude);
title('Амплитудный спектр');
xlabel('Частота (Гц)');
ylabel('Амплитуда');

subplot(2, 1, 2);
plot(frequencies(1:N/2), half_amplitude);
hold on;
scatter(frequencies(peak_indices), peaks, 'r', 'filled');
title('Половина амплитудного спектра с пиками');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
legend('Амплитуда', 'Пики');

% Отображение сетки
grid on;
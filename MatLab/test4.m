addpath(genpath('D:\Develop\Amadeus\matlab-midi-master\src'))

mifiFile = readmidi('testm.mid');

midiData = midiInfo(mifiFile);

disp(midiData);
simplesynth(midiData);

function wave = wavefunction(samplefreq, freq, time, amplitude)
    constant_exp = -0.0015;
    n = 6;
    T = (0:1/samplefreq:time);
    wave = zeros(size(T));
    
    number_sin = 2 * pi .* freq;
    number_exp = constant_exp * number_sin;
    for j = 1:n
        wave = wave + amplitude .* sin(j * number_sin * T) .* exp(number_exp * T) ./ 2^(j-1);
    end 
    wave = (wave + wave.^(4))/n;
end


function simplesynth(midiData)
[numRow, numCol] = size(midiData);
time = (midiData(numRow, 5))+1;
size_arr = (int32(44100*time));
wave_arr = zeros(1, size_arr);
freq = [];
amplitude = [];
duration = [];

for i = 1:length(midiData)
    note = midiData(i,3);
    freq_note = 440 * 2.^((note-73)/12);
    freq = [freq; freq_note];
    amplitude = [amplitude; midiData(i,4) / 127];
    duration = [duration; midiData(i,6)- midiData(i,5)];

    if i ~= numRow
        if midiData(i,5) ~= midiData(i+1,5)
            wave = wavefunction(44100, freq, duration, amplitude);
            if length(freq) ~= 1
                
                wave = sum(wave);
                maxValue = max(abs(wave));
                wave = wave/maxValue;

            else
                maxValue = max(abs(wave));
                wave = wave/maxValue;
            end
            % soundsc(wave, 44100);
            startIndex = int32(44100 * midiData(i,5)) + 1;
            wave_arr(startIndex:startIndex + length(wave) - 1) =+ wave;
            freq = [];
            amplitude = [];
        end
    end
end
    % maxValue = max(abs(wave_arr));
    player = audioplayer(wave_arr, 44100);
    play(player);
    % soundsc(wave_arr, 44100);
end
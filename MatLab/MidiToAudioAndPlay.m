fluidsynthPath = 'D:\Develop\Amadeus\Materials\FluidSynth\bin\fluidsynth.exe';

midiFilePath = 'D:\Develop\Amadeus\Materials\Sound\All_I_Need.mid';

playPiano(midiFilePath);
playGuitar(midiFilePath);
playOrgan(midiFilePath);
audioFilePath = playViolin(midiFilePath);

playAudio(audioFilePath);


function audioFilePath = playPiano(midiFilePath)
    soundFontPath = 'D:\Develop\Amadeus\Materials\SoundFont\piano.sf2';
    % Выходной аудиофайл
    audioFilePath = 'D:\Develop\Amadeus\Materials\outputPiano.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end

function audioFilePath = playViolin(midiFilePath)
    soundFontPath = 'D:\Develop\Amadeus\Materials\SoundFont\violin.sf2';
    % Выходной аудиофайл
    audioFilePath = 'D:\Develop\Amadeus\Materials\outputViolin.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end
   
function audioFilePath = playGuitar(midiFilePath)
    soundFontPath = 'D:\Develop\Amadeus\Materials\SoundFont\guitar.sf2';
    % Выходной аудиофайл
    audioFilePath = 'D:\Develop\Amadeus\Materials\outputGuitar.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end

function audioFilePath = playOrgan(midiFilePath)
    soundFontPath = 'D:\Develop\Amadeus\Materials\SoundFont\organ.sf2';
    % Выходной аудиофайл
    audioFilePath = 'D:\Develop\Amadeus\Materials\outputOrgan.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end

function playAudio(audioFilePath)
    [y,Fs] = audioread(audioFilePath);
    sound(y, Fs);
end
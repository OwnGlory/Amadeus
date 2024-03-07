fluidsynthPath = 'Materials\FluidSynth\bin\fluidsynth.exe';

% midiFilePath = 'Materials\Sound\All_I_Need.mid';
midiFilePath = 'Materials\testout2.mid';

playPiano(midiFilePath, fluidsynthPath);
playGuitar(midiFilePath, fluidsynthPath);
playOrgan(midiFilePath, fluidsynthPath);
playViolin(midiFilePath, fluidsynthPath);

% playAudio(audioFilePath);


function audioFilePath = playPiano(midiFilePath, fluidsynthPath)
    soundFontPath = 'Materials\SoundFont\piano.sf2';
    % Выходной аудиофайл
    audioFilePath = 'Materials\outputPiano.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end

function audioFilePath = playViolin(midiFilePath, fluidsynthPath)
    soundFontPath = 'Materials\SoundFont\violin.sf2';
    % Выходной аудиофайл
    audioFilePath = 'Materials\outputViolin.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end
   
function audioFilePath = playGuitar(midiFilePath, fluidsynthPath)
    soundFontPath = 'Materials\SoundFont\guitar.sf2';
    % Выходной аудиофайл
    audioFilePath = 'Materials\outputGuitar.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end

function audioFilePath = playOrgan(midiFilePath, fluidsynthPath)
    soundFontPath = 'Materials\SoundFont\organ.sf2';
    % Выходной аудиофайл
    audioFilePath = 'Materials\outputOrgan.wav';
    % Команда для конвертации MIDI в аудио
    command = sprintf('%s -a coreaudio -g 0.5 -l -F %s %s %s', fluidsynthPath, audioFilePath, soundFontPath, midiFilePath);
    % Вызов FluidSynth для конвертации MIDI в аудио
    system(command);
    
end

function playAudio(audioFilePath)
    [y,Fs] = audioread(audioFilePath);
    sound(y, Fs);
end
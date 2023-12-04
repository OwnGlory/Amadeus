readme = fopen('Cymatics - All I Need - 165 BPM D# Min.mid');

[readOut, byteCount] = fread(readme);
fclose(readme);
% Concatenate ticksPerQNote from 2 bytes
ticksPerQNote = polyval(readOut(13:14),256);

% Initialize values
chunkIndex = 14; % Header chunk is always 14 bytes
ts = 0; % Timestamp - Starts at zero
BPM = 140;
msgArray = [];
durationArray = [];
samplefreq = 44100;

% Parse track chunks in outer loop
    while chunkIndex < byteCount
     
     % Read header of track chunk, find chunk length 
        % Add 8 to chunk length to account for track chunk header length
     chunkLength = polyval(readOut(chunkIndex+(5:8)),256)+8;
     
     ptr = 8+chunkIndex; % Determine start for MIDI event parsing
     statusByte = -1; % Initialize statusByte. Used for running status support
        
        % Parse MIDI track events in inner loop
        while ptr < chunkIndex+chunkLength
          % Read delta-time
            [deltaTime,deltaLen] = findVariableLength(ptr,readOut); 
          % Push pointer to beginning of MIDI message
            ptr = ptr+deltaLen;
     
     % Read MIDI message
            [statusByte,messageLen,message] = interpretMessage(statusByte,ptr,readOut);
     % Extract relevant data - Create midimsg object
            [ts,msg] = createMessage(message,ts,deltaTime,ticksPerQNote,BPM);
            durationData = (deltaTime / ticksPerQNote) * (60 / BPM);
            durationArray = [durationArray, durationData];
     % Add midimsg to msgArray
            msgArray = [msgArray; msg];
     % Push pointer to next MIDI message
            ptr = ptr+messageLen;
        end
        
        % Push chunkIndex to next track chunk
     chunkIndex = chunkIndex+chunkLength;
    end

% disp(msgArray);

simplesynth (msgArray, durationArray);

function [valueOut,byteLength] = findVariableLength(lengthIndex,readOut)

byteStream = zeros(4,1);

for i = 1:4
    valCheck = readOut(lengthIndex+i);
    byteStream(i) = bitand(valCheck,127);   % Mask MSB for value
    if ~bitand(valCheck,uint32(128))        % If MSB is 0, no need to append further
        break
    end
end

valueOut = polyval(byteStream(1:i),128);    % Base is 128 because 7 bits are used for value
byteLength = i;

end

function [statusOut,lenOut,message] = interpretMessage(statusIn,eventIn,readOut)

% Check if running status
introValue = readOut(eventIn+1);
if isStatusByte(introValue)
    statusOut = introValue;         % New status
    running = false;
else
    statusOut = statusIn;           % Running status—Keep old status
    running = true;
end

switch statusOut
    case 255     % Meta-event (FF)—IGNORE
        [eventLength, lengthLen] = findVariableLength(eventIn+2, ...
            readOut);   % Meta-events have an extra byte for type of meta-event
        lenOut = 2+lengthLen+eventLength;
        message = -1;
    case 240     % Sysex message (F0)—IGNORE
        [eventLength, lengthLen] = findVariableLength(eventIn+1, ...
            readOut);
        lenOut = 1+lengthLen+eventLength;
        message = -1;
        
    case 247     % Sysex message (F7)—IGNORE
        [eventLength, lengthLen] = findVariableLength(eventIn+1, ...
            readOut);
        lenOut = 1+lengthLen+eventLength;
        message = -1;
    otherwise    % MIDI message—READ
        eventLength = msgnbytes(statusOut);
        if running  
            % Running msgs don't retransmit status—Drop a bit
            lenOut = eventLength-1;
            message = uint8([statusOut;readOut(eventIn+(1:lenOut))]);
            
        else
            lenOut = eventLength;
            message = uint8(readOut(eventIn+(1:lenOut)));
        end
end

end

% ----

function n = msgnbytes(statusByte)

if statusByte <= 191        % hex2dec('BF')
    n = 3;
elseif statusByte <= 223    % hex2dec('DF')
    n = 2;
elseif statusByte <= 239    % hex2dec('EF')
    n = 3;
elseif statusByte == 240    % hex2dec('F0')
    n = 1;
elseif statusByte == 241    % hex2dec('F1')
    n = 2;
elseif statusByte == 242    % hex2dec('F2')
    n = 3;
elseif statusByte <= 243    % hex2dec('F3')
    n = 2;
else
    n = 1;
end

end

% ----

function yes = isStatusByte(b)
yes = b > 127;
end

function [tsOut,msgOut] = createMessage(messageIn,tsIn,deltaTimeIn,ticksPerQNoteIn,bpmIn)

if messageIn < 0     % Ignore Sysex message/meta-event data
    tsOut = tsIn;
    msgOut = midimsg(0);
    return
end

% Create RawBytes field
messageLength = length(messageIn);
zeroAppend = zeros(8-messageLength,1);
bytesIn = transpose([messageIn;zeroAppend]);

% deltaTimeIn and ticksPerQNoteIn are both uints
% Recast both values as doubles
d = double(deltaTimeIn);
t = double(ticksPerQNoteIn);

% Create Timestamp field and tsOut
msPerQNote = 6e7/bpmIn;
timeAdd = d*(msPerQNote/t)/1e6;
tsOut = tsIn+timeAdd;

% Create midimsg object
midiStruct = struct('RawBytes',bytesIn,'Timestamp',tsOut);
msgOut = midimsg.fromStruct(midiStruct);

end

function wave = wavefunction(samplefreq, note, time, amplitude)
    constant_exp = -0.0004;
    n = 6;
    T = (0:1/samplefreq:time);
    wave = zeros(size(T));
    freq = 440 * 2.^((note-73)/12);
    number_sin = 2 * pi * freq;
    number_exp = constant_exp * number_sin;
    
    for j = 1:n
        wave = wave + amplitude * sin(j * number_sin * T) .* exp(number_exp * T) ./ 2^(j-1);
    end
    
    wave = (wave + wave.^3) / n;
end


function simplesynth(msgArray, durationArray)
k = 1;
i = 0;
note = 0;
notes = [];
amplitude = 0;
time = msgArray(length(msgArray)).Timestamp+1;
size_arr = (int32(44100*time));
wave_arr = zeros(1, size_arr);
nonZeroIndices = find(durationArray ~= 0);
timeArray = durationArray(nonZeroIndices);
disp(msgArray);

dataCellArray = cell(length(msgArray), 3);

for j = 1:length(msgArray)
    msg = msgArray(j);
    duration = timeArray(k)+2;

    if isNoteOn(msg)
        dataCellArray{j, 1} = msg.Timestamp;
        dataCellArray{j, 2} = note;
        dataCellArray{j, 3} = msg.Velocity;
        note = msg.Note;
        amplitude = msg.Velocity / 127;
    elseif isNoteOff(msg)
        if msg.Note == msg.Note
            amplitude = 0;
        end
    end

    wave = wavefunction(44100, note, duration, amplitude);
    startIndex = int32(44100 * msgArray(j).Timestamp) + 1;
    wave_arr(startIndex:startIndex + length(wave)-1) =+ wave;

    if j ~= length(msgArray)
        if msgArray(j).Timestamp ~= msgArray(j+1).Timestamp
            k =+ 1;
        end
    end
end
    maxValue = max(abs(wave_arr));
    dataTable = cell2table(dataCellArray, 'VariableNames', {'Timestamp', 'Note', 'Velocity'});

    fileName = 'output.txt';

    writetable(dataTable, fileName);
    % sound(wave_arr/maxValue, 44100);
end

% ----

function yes = isNoteOn(msg)
yes = strcmp(msg.Type,'NoteOn') ...
    && msg.Velocity > 0;
end

% ----

function yes = isNoteOff(msg)
yes = strcmp(msg.Type,'NoteOff') ...
    || (strcmp(msg.Type,'NoteOn') && msg.Velocity == 0);
end

% ----

function freq = note2freq(note)
    freq = 440 * 2.^((note-69)/12);
end
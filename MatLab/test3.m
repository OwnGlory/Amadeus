addpath(genpath('D:\Develop\Amadeus\matlab-midi-master\src'))

mifiFile = readmidi('Cymatics - All I Need - 165 BPM D# Min.mid');

midiData = midiInfo(mifiFile);

disp(midiData);
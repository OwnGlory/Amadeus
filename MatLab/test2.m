readme = fopen('Cymatics - Baby - 152 BPM A# Min.mid');
[readOut, byteCount] = fread(readme);
fclose(readme);
% Concatenate ticksPerQNote from 2 bytes
ticksPerQNote = polyval(readOut(13:14),256);

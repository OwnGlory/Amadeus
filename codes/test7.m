
filename = 'testm.mid';

fid = fopen(filename, 'rb');

if fid == -1
    error('Не удалось открыть файл.');
end

binaryData = fread(fid, '*uint8');

fclose(fid);

array = [];
valueToFind = 144;
instr = 41;
chan = 0;
programChange = [192; instr; chan];
indices = find(binaryData == 192);

if indices
    binaryData(indices(1,1)+1,1) = 41;
    array = binaryData;
else
    startIndices = strfind(binaryData', uint8('MTrk'));
    startIndex = startIndices(1);
    lengthBytes = binaryData(startIndex + 4 : startIndex + 7);
    binaryData(startIndex + 7, 1) = binaryData(startIndex + 7) + 3;

    indices = find(binaryData == valueToFind);
    array = [array; binaryData(1:indices(1,1)-1,1)];
    array = [array; programChange];
    array = [array; binaryData(indices(1,1):length(binaryData),1)];

end

fid = fopen('D:\Develop\Amadeus\output.mid', 'wb');
fwrite(fid, array, '*uint8');
fclose(fid);

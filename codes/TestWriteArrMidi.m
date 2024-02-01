filename = 'Materials\output42.txt';

% Откройте файл для записи
fileID = fopen(filename,'w');
% Запишите данные в файл
for i = 1:length(Note)
    fprintf(fileID, '1,0,%d,%d,%.3f,%.3f\n', Note(i), Velocity(i), FiveCol(i), SixCol(i));
end

% Закройте файл
fclose(fileID);
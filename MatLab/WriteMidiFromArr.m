function WriteMidiFromArr(filename, NoteNumArr, Velocity, FiveCol, SixCol)
    % Откройте файл для записи
    fileID = fopen(filename,'w');
    % Запишите данные в файл
    for i = 1:length(NoteNumArr)
        fprintf(fileID, '1,0,%d,%d,%.3f,%.3f\n', NoteNumArr(i), Velocity(i), FiveCol(i), SixCol(i));
    end

    % Закройте файл
    fclose(fileID);
end


function DefinitionDuration(quantity_windows)
    noteWinDur = windowSize + ((windowSize / 3) * quantity_windows - 1);
    if noteWinDur < eighth
        sixteenth;
    end
    if noteWinDur >= (sixteenth + sixteenth_half) && noteWinDur < quarter
        eighth;
    end
    if noteWinDur >= (eigth + eigth_half) && noteWinDur < half
        quarter;
    end
    if noteWinDur >= (quarter + quarter_half) && noteWinDur < whole
        half;
    end
    if noteWinDur >= (half + half_half)
        whole;
    end   
end


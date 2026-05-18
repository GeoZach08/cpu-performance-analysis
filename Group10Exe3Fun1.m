% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

function p_val = Group10Exe3Fun1(data, n, idx)
    % Epilogh ths sthlhs poy mas endiaferei
    selected_column = data(:, idx);
    
    % Epilogh tyxaiwn parathrhsewn xwris epanathesh
    y = datasample(selected_column, n, 'Replace', false);
    
    % ELegxos an to deigma y proerxetai apo thn idia kanatomh me to
    % selected_column. 
    % H "kstest2" ektelei elegxo Kolmogorov-Smirnov gia 2 deigmata kai
    % epistrefei thn timh p_val, h opoia ekfrazei thn pithanothta oi
    % diafores anamesa sta deigmata na ofeilontai kathara sthn tyxaiothta ths
    % deigmatolhpsias. 
    [~, p_val] = kstest2(y,selected_column);
    
end
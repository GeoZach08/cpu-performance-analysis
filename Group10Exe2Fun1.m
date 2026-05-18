% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

function p_val = Group10Exe2Fun1(data, n, idx)
    % Epilogh ths sthlhs poy mas endiaferei
    selected_column = data(:, idx);
    
    % Epilogh tyxaiwn parathrhsewn xwris epanathesh
    y = datasample(selected_column, n, 'Replace', false);
    
    % ELegxos x2 kalhs prosarmoghs
    [~, p_val] = chi2gof(y);
    
end
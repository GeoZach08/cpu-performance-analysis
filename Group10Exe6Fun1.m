function ci_r = Group10Exe6Fun1(x, y, alpha)
% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 6 - Function
% Skopos: Ypologismos diastimatos empistosynis gia ton syntelesti
% sysxetisis Pearson me xrisi metasximatismou Fisher.
% Inputs:
%   x, y: Ta dyo dianysmata tou deigmatos
%   alpha: Epipedo simantikotitas 
% Outputs:
%   ci_r: To diastima empistosynis  gia to r

    n = length(x);
    
    % 1. Ypologismos tou deigmatikou syntelesti sysxetisis 
    r_matrix = corrcoef(x, y);
    r = r_matrix(1, 2);
    
    % 2. Metasximatismos Fisher 
    % z = 0.5 * ln((1+r)/(1-r)) = atanh(r)
    z = 0.5 * log((1 + r) / (1 - r));
    
    % 3. Typiko sfalma tou z 
    se_z = 1 / sqrt(n - 3);
    
    % 4. Kritiki timi apo thn Typopoihmeni Kanoniki Katanomi 
    z_crit = norminv(1 - alpha/2);
    
    % 5. Diastima empistosynis gia to z
    z_lower = z - z_crit * se_z;
    z_upper = z + z_crit * se_z;
    
    % 6. Antistrofos metasximatismos gia na gyrissoume sto r
    % r = (exp(2z)-1)/(exp(2z)+1) = tanh(z)
    ci_r(1) = tanh(z_lower);
    ci_r(2) = tanh(z_upper);

end
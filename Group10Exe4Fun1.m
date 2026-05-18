function [ci_param, ci_boot] = Group10Exe4Fun1(sample_data, alpha)
% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 4 - Function
% Inputs:
%   sample_data: To mikro deigma (n=20)
%   alpha: Epipedo simantikotitas 
% Outputs:
%   ci_param: To parametriko diastima empistosynis 
%   ci_boot: To bootstrap diastima empistosynis 

    n = length(sample_data);
    
    %  1. Parametriko Diastima  
    mu_est = mean(sample_data);
    sigma_est = std(sample_data);
    se = sigma_est / sqrt(n); % Typiko sfalma
    
    % Kritiki timi t (gia n-1 vathmous eleutherias)
    t_crit = tinv(1 - alpha/2, n-1);
    
    % Ypologismos oriwn
    ci_param = [mu_est - t_crit*se, mu_est + t_crit*se];
    
    
    %  2. Bootstrap Diastima 
    
    boot_result = bootci(1000, {@mean, sample_data}, 'Alpha', alpha, 'type', 'per');
    
    % H bootci epistrefei stili [min; max], opote vazoume ' 
    ci_boot = boot_result'; 
    
end
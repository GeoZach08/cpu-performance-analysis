% Omada 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 1 - Program
% Skopos: N=209, M=50 epanalipseis, n=100 deigma.
% Sygkrisi deigmatoliptikis katanomis me tin pragmatiki.

clc;
clear;
close all;

% 1. Fortosi dedomenon (Load Data)
filename = 'CPUperformance.xlsx';
try
    data = xlsread(filename);
catch
    error('To arxeio CPUperformance.xlsx den vrethike.');
end

% Indices of columns required: MYCT(3), CACH(6), CHMIN(7)
col_indices = [3, 6, 7];
col_names = {'MYCT', 'CACH', 'CHMIN'};

% Parametroi
N = 209; % Synolo paratiriseon
n = 100; % Megethos deigmatos
M = 50;  % Arithmos epanalipseon

% Epanalipsi gia kathe deikti (Attribute)
figure('Name', 'Group10 - Zhtima 1', 'NumberTitle', 'off');

for k = 1:length(col_indices)
    col_idx = col_indices(k);
    attribute_data = data(:, col_idx); % Ola ta N dedomena
    
    subplot(1, 3, k);
    hold on;
    title(['Attribute: ', col_names{k}]);
    xlabel('Value');
    ylabel('PDF');
    
    % a) Sxediasmos M kampylwn apo ta M deigmata twn n=100
    % Loop M times calling the function
    for i = 1:M
        [x_sample, y_sample] = Group10Exe1Fun1(attribute_data, n);
        % Plot me lepti grammi kai diafaneia (cyan/blue)
        plot(x_sample, y_sample, 'Color', [0.5 0.5 0.5 0.3], 'LineWidth', 1);
    end
    
    % b) Sxediasmos tis pragmatikis empeirikis PDF (N=209)
    [counts_total, edges_total] = histcounts(attribute_data, 'Normalization', 'pdf');
    x_total = (edges_total(1:end-1) + edges_total(2:end)) / 2;
    y_total = counts_total;
    
    % Plot me entono xrwma (Kokkino) gia na ksexwrizei
    h_main = plot(x_total, y_total, 'r-', 'LineWidth', 2.5);
    
    % Leganta mono gia tin kyria kampyli
    legend(h_main, 'Total Data PDF (N=209)', 'Location', 'best');
    hold off;
end

% --- SXOLIASMOS & SYMPERASMATA  ---
fprintf('--- Symperasmata Zhtima 1 ---\n');
fprintf('Paratiroume sta diagrammata oti oi M=50 kampyles (gkri) pou proerxontai\n');
fprintf('apo ta deigmata twn n=100 paratiriseon akolouthoun tin geniki morfi tis\n');
fprintf('pragmatikis katanomis (kokkini grammi).\n');
fprintf('Ostoso, yparxei variablity (metavlitotita), eidika stis koryfes.\n');
fprintf('Gia tous deiktes MYCT, CACH, CHMIN, oi katanomes einai entona asymmetres\n');
fprintf('(right-skewed), me megali sygkentrwsi se xamiles times kai "oures" pros ta deksia.\n');
fprintf('Den fainetai na proseggizoun tin Kanoniki Katanomi, alla isws Ekthetiki (Exponential)\n');
fprintf('h Gamma katanomi.\n');
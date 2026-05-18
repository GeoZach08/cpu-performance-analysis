% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 6 - Program
% Skopos: Diastimata empistosynis gia Correlation 
% Metavlites: MMAX (Col 5) vs CHMIN (Col 7).
% M=100 epanalipseis, n=20 deigma.

clc;
clear;

% 1. Fortosi dedomenon
filename = 'CPUperformance.xlsx';
try
    data = xlsread(filename);
catch
    error('To arxeio CPUperformance.xlsx den vrethike.');
end

% Indices: MMAX(5), CHMIN(7)
col_idx1 = 5; % MMAX
col_idx2 = 7; % CHMIN

x_pop = data(:, col_idx1);
y_pop = data(:, col_idx2);

N = length(x_pop);
n = 20;   % Megethos deigmatos
M = 100;  % Arithmos epanalipseon
alpha = 0.05;

fprintf('--- APOTELESMATA ZHTIMA 6 ---\n');
fprintf('Elegxos Diastimatos Empistosynis Syntelesti Sysxetisis (Fisher)\n');
fprintf('Metavlites: MMAX vs CHMIN\n\n');

% MEROS 1: ARXIKA DEDOMENA  

% Ypologismos pragmatikis sysxetisis sto synolo (N=209)
R_true_matrix = corrcoef(x_pop, y_pop);
R_true = R_true_matrix(1, 2);

count_cover = 0;

for i = 1:M
    % Tyxaia epilogi deigmatos n=20
    idx = randperm(N, n);
    x_sample = x_pop(idx);
    y_sample = y_pop(idx);
    
    % Klisi synartisis gia CI
    ci = Group10Exe6Fun1(x_sample, y_sample, alpha);
    
    % Elegxos an to R_true einai mesa sto diastima
    if R_true >= ci(1) && R_true <= ci(2)
        count_cover = count_cover + 1;
    end
end

perc_cover = (count_cover / M) * 100;

fprintf('RAW DATA:\n');
fprintf('True Correlation (N=%d): %.4f\n', N, R_true);
fprintf('Coverage Percentage (Samples n=%d): %.1f%%\n\n', n, perc_cover);


% ===== MEROS 2: LOGARITHMIMENA DEDOMENA (LOG) =====

% Filtrarisma gia na apofygoume log(0) -> -Inf
valid_idx = (x_pop > 0) & (y_pop > 0);
x_pop_log = log(x_pop(valid_idx));
y_pop_log = log(y_pop(valid_idx));
N_log = length(x_pop_log);

% Pragmatiki sysxetisis sta logarihmimena
R_true_log_matrix = corrcoef(x_pop_log, y_pop_log);
R_true_log = R_true_log_matrix(1, 2);

count_cover_log = 0;

for i = 1:M
    % Tyxaia epilogi apo ta valida log dedomena
    idx_log = randperm(N_log, n);
    x_sample_log = x_pop_log(idx_log);
    y_sample_log = y_pop_log(idx_log);
    
    % Klisi synartisis
    ci_log = Group10Exe6Fun1(x_sample_log, y_sample_log, alpha);
    
    if R_true_log >= ci_log(1) && R_true_log <= ci_log(2)
        count_cover_log = count_cover_log + 1;
    end
end

perc_cover_log = (count_cover_log / M) * 100;

fprintf('LOG DATA:\n');
fprintf('True Correlation (Log-Log): %.4f\n', R_true_log);
fprintf('Coverage Percentage: %.1f%%\n', perc_cover_log);

% SXOLIASMOS 
fprintf('\n--- Symperasmata ---\n');
fprintf('1. O syntelestis sysxetisis einai euaisthitos se akraies times (outliers).\n');
fprintf('   Sta RAW dedomena, epeidi yparxoun polla outliers (asymmetria),\n');
fprintf('   ta mikra deigmata mporei na dwsoyn poli diaforetiko r apo to R_true,\n');
fprintf('   rixnontas to pososto kalypsis katw apo to 95%%.\n');
fprintf('2. Sta LOG dedomena, oi sxeseis ginetai pio grammikes kai oi katanomes\n');
fprintf('   pio kanonikes. Etsi, o metasximatismos Fisher douleuei kalytera\n');
fprintf('   kai anamenoume to pososto kalypsis na einai pio konta sto 95%%.\n');
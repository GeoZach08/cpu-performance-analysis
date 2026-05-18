% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 7 - Program
% Skopos: Sygkrisi Parametrikou Elegxou vs Elegxou Tyxaiopoiisis
% gia H0: correlation=0.
% Metavlites: MMAX (Col 5) vs CHMIN (Col 7).

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
col_idx1 = 5;
col_idx2 = 7;

x_pop = data(:, col_idx1);
y_pop = data(:, col_idx2);

% Parametroi
n = 20;   % Megethos deigmatos
M = 100;  % Arithmos epanalipseon (opws sto Q6/Q4)
alpha = 0.05;

fprintf('--- APOTELESMATA ZHTIMA 7 ---\n');
fprintf('Pososto Aporripsis H0 (Statistika Simantiki Sysxetisi)\n');
fprintf('Stoxos: Na doume an oi dyo methodoi symfwnoun.\n\n');

% MEROS 1: ARXIKA DEDOMENA 
rej_count_param = 0;
rej_count_rand = 0;

% Set seed gia epanalipsimotita (proairetiko)
rng(10); 

for i = 1:M
    % Tyxaia epilogi
    idx = randperm(length(x_pop), n);
    x_sample = x_pop(idx);
    y_sample = y_pop(idx);
    
    [rp, rr] = Group10Exe7Fun1(x_sample, y_sample, alpha);
    
    rej_count_param = rej_count_param + rp;
    rej_count_rand = rej_count_rand + rr;
end

fprintf('RAW DATA:\n');
fprintf('Parametric Test Rejection Rate:   %5.1f%%\n', (rej_count_param/M)*100);
fprintf('Randomization Test Rejection Rate:%5.1f%%\n\n', (rej_count_rand/M)*100);

% MEROS 2: LOGARITHMIMENA DEDOMENA 
valid_idx = (x_pop > 0) & (y_pop > 0);
x_pop_log = log(x_pop(valid_idx));
y_pop_log = log(y_pop(valid_idx));

rej_count_param_log = 0;
rej_count_rand_log = 0;

for i = 1:M
    idx_log = randperm(length(x_pop_log), n);
    x_sample_log = x_pop_log(idx_log);
    y_sample_log = y_pop_log(idx_log);
    
    [rp_log, rr_log] = Group10Exe7Fun1(x_sample_log, y_sample_log, alpha);
    
    rej_count_param_log = rej_count_param_log + rp_log;
    rej_count_rand_log = rej_count_rand_log + rr_log;
end

fprintf('LOG DATA:\n');
fprintf('Parametric Test Rejection Rate:   %5.1f%%\n', (rej_count_param_log/M)*100);
fprintf('Randomization Test Rejection Rate:%5.1f%%\n', (rej_count_rand_log/M)*100);

% SXOLIASMOS 
fprintf('\n--- Symperasmata ---\n');
fprintf('1. Sta RAW dedomena, pou exoun akraies times (outliers), o parametrikos\n');
fprintf('   elegxos (Pearson/Student) mporei na einai pio "austiros" h na epireazetai\n');
fprintf('   apo tin elleipsi kanonikotitas. O elegxos tyxaiopoiisis den proypothetei\n');
fprintf('   kanonikotita, opote thewreitai pio aksiopistos edw.\n');
fprintf('   An ta pososta diaferoun simantika, tote i kanonikotita paraviazetai entona.\n');
fprintf('2. Sta LOG dedomena, opou i sxesi ginetai pio grammiki kai ta dedomena\n');
fprintf('   pio kanonika, anamenoume oi dyo methodoi na symfwnoun sxedon apolyta.\n');
fprintf('   To pososto aporripsis edw anamenetai ypsilotero giati i sxesi (sysxetisi)\n');
fprintf('   anadeiknyetai kalytera meta ton logarithmo.\n');
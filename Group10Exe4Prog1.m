% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 4 - Program
% Skopos: Ypologismos 95% CI gia ti mesi timi (Parametric vs Bootstrap).
% Elegxos an "pianoun" tin pragmatiki mesi timi.
% M=100 epanalipseis, n=20 megethos deigmatos.

clc;
clear;

% 1. Fortosi dedomenon
data=readmatrix("CPUperformance.xlsx");

% Indices: MYCT(3), MMAX(5), CHMIN(7)
col_indices = [3, 5, 7];
col_names = {'MYCT', 'MMAX', 'CHMIN'};

% Parametroi
n = 20;   % Megethos deigmatos (mikro!)
M = 100;  % Arithmos epanalipseon
alpha = 0.05;

fprintf('--- APOTELESMATA ZHTIMA 4 ---\n');
fprintf('Pososto kalypsis (Coverage Probability) twn 95%% CI\n');
fprintf('Stoxos: To pososto na einai konta sto 95%%\n\n');

for k = 1:length(col_indices)
    col_idx = col_indices(k);
    pop_data = data(:, col_idx); % Olo to N=209
    
    fprintf('--- Attribute: %s ---\n', col_names{k});
    
    %  MEROS 1: ARXIKA DEDOMENA 
    true_mean = mean(pop_data); % H pragmatiki mesi timi
    
    count_param = 0;
    count_boot = 0;
    
    for i = 1:M
        % Tyxaio deigma n=20
        idx = randperm(length(pop_data), n);
        sample_vals = pop_data(idx);
        
        [ci_par, ci_bt] = Group10Exe4Fun1(sample_vals, alpha);
        
        % Elegxos an to CI periexei tin pragmatiki timi
        if true_mean >= ci_par(1) && true_mean <= ci_par(2)
            count_param = count_param + 1;
        end
        
        if true_mean >= ci_bt(1) && true_mean <= ci_bt(2)
            count_boot = count_boot + 1;
        end
    end
    
    fprintf('RAW DATA -> Parametric: %3d%% | Bootstrap: %3d%%\n', ...
        count_param, count_boot);
    
    % ===== MEROS 2: LOGARITHMIMENA DEDOMENA (LOG) =====
    valid_idx = pop_data > 0;
    pop_data_log = log(pop_data(valid_idx));
    true_mean_log = mean(pop_data_log);
    
    count_param_log = 0;
    count_boot_log = 0;
    
    for i = 1:M
        idx_log = randperm(length(pop_data_log), n);
        sample_vals_log = pop_data_log(idx_log);
        
        [ci_par_log, ci_bt_log] = Group10Exe4Fun1(sample_vals_log, alpha);
        
        if true_mean_log >= ci_par_log(1) && true_mean_log <= ci_par_log(2)
            count_param_log = count_param_log + 1;
        end
        
        if true_mean_log >= ci_bt_log(1) && true_mean_log <= ci_bt_log(2)
            count_boot_log = count_boot_log + 1;
        end
    end
    
    fprintf('LOG DATA -> Parametric: %3d%% | Bootstrap: %3d%%\n', ...
        count_param_log, count_boot_log);
    fprintf('--------------------------------------\n');
end

% --- SXOLIASMOS ---
fprintf('\n--- Symperasmata ---\n');
fprintf('1. Sta RAW dedomena, epeidi oi katanomes einai asymmetres (oxi Kanonikes),\n');
fprintf('   to Parametriko CI  mporei na exei xamilo pososto kalypsis (<95%%),\n');
fprintf('   giati vasizetai stin proypothesi tis Kanonikotitas.\n');
fprintf('   To Bootstrap synithws ta paei ligo kalytera alla dyskoleuetai ki auto\n');
fprintf('   se toso mikra deigmata (n=20) .\n');
fprintf('2. Sta LOG dedomena, i katanomi ginetai pio symmetriki (Kanoniki).\n');
fprintf('   Edw anamenoume ta pososta na einai poly konta sto thewritiko 95%%,\n');
fprintf('   toso gia to Parametriko oso kai gia to Bootstrap.\n');
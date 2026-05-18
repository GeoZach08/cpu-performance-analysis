% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 10 - Program
% Skopos: Sygkrisi Full Model, PCR, LASSO gia kataskeuastes me N > 10.
% Methodos: Split 65% Train - 35% Test. Krtirio: MSE.

clc;
clear;

% 1. Fortosi dedomenon
filename = 'CPUperformance.xlsx'; 
try
    data = xlsread(filename);
catch
    error('To arxeio CPUperformance.xlsx den vrethike.');
end

% Column Indices:
% Col 1: Vendor Code (numeric 1-12)
% Col 3-8: Features (Predictors)
% Col 9: Target 
vendor_col = data(:, 1);
X_all = data(:, 3:8);
Y_all = data(:, 9);

% 2. Euresi Kataskeuastwn me > 10 deigmata
unique_vendors = unique(vendor_col);
valid_vendors = []; % Edw tha apothikeysoume tous kodikous tous

% Metrame poses fores emfanizetai kathe vendor
for v = unique_vendors'
    count = sum(vendor_col == v);
    if count > 10
        valid_vendors = [valid_vendors, v];
    end
end

fprintf('--- APOTELESMATA ZHTIMA 10 ---\n');
fprintf('Vrethikan %d kataskeuastes me > 10 deigmata.\n', length(valid_vendors));
fprintf('Tha ginei sygkrisi MSE (Mean Squared Error) sto Test Set (35%%).\n\n');
fprintf('%-10s | %-12s | %-12s | %-12s\n', 'Vendor ID', 'MSE Full', 'MSE PCR', 'MSE LASSO');
fprintf('----------------------------------------------------------\n');

% 3. Epanalipsi gia kathe epilegmeno Vendor
rng(42); % Gia epanalipsimotita twn tyxaiwn split

for v = valid_vendors
    % Vriskoume tis grammes gia ton sygkekrimeno vendor
    idx_vendor = (vendor_col == v);
    
    X_vendor = X_all(idx_vendor, :);
    Y_vendor = Y_all(idx_vendor);
    
    n_samples = length(Y_vendor);
    
    % 4. Dimiourgia Train (65%) / Test (35%) Split
    % Xrisimopoioume cvpartition gia tyxaio diaxwrismo
    cv = cvpartition(n_samples, 'HoldOut', 0.35);
    idx_train = training(cv);
    idx_test = test(cv);
    
    X_train = X_vendor(idx_train, :);
    Y_train = Y_vendor(idx_train);
    
    X_test = X_vendor(idx_test, :);
    Y_test = Y_vendor(idx_test);
    
    % 5. Klisi tis synartisis gia ta montela
    [mse_f, mse_p, mse_l] = Group10Exe10Fun1(X_train, Y_train, X_test, Y_test);
    
    % Ektypwsi apotelesmatwn
    fprintf('%-10d | %12.2f | %12.2f | %12.2f\n', v, mse_f, mse_p, mse_l);
end

% --- SXOLIASMOS ---
fprintf('\n--- Symperasmata ---\n');
fprintf('1. To Full Linear Model xrisimopoiei oles tis metavlites. An yparxei \n');
fprintf('   polysyggrammikotita (multicollinearity), mporei na exei asynepi apotelesmata.\n');
fprintf('2. To PCR meiwnei tis diastaseis kratwntas mono tis kyries synistwses.\n');
fprintf('   An to MSE tou PCR einai mikrotero, simainei oti ypirxe "thorivos" sta dedomena\n');
fprintf('   pou to PCA katafere na afairesei.\n');
fprintf('3. To LASSO kanei aytomati epilogi xaraktiristikwn midenizontas syntelestes.\n');
fprintf('   Se dataset me polla features pou den xreiazontai, to LASSO synithws kerdizei.\n');
fprintf('   Sygkrinete ta noumera MSE gia na deite poio montelo kerdizei se kathe vendor.\n');
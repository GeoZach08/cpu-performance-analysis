function [mse_full, mse_pcr, mse_lasso] = Group10Exe10Fun1(X_train, Y_train, X_test, Y_test)
% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 10 - Function
% Skopos: Ekpaideusi 3 montelwn (Full, PCR, LASSO) kai ypologismos MSE
% sto Test set.
% Inputs:
%   X_train, Y_train: Dedomena Ekpaideusis (65%)
%   X_test, Y_test:   Dedomena Elegxou (35%)
% Outputs:
%   mse_full, mse_pcr, mse_lasso: To Meso Tetragwniko Sfalma gia kathe montelo.

    %  1. FULL LINEAR MODEL 
    % Xrisimopoioume tin fitlm pou kanei aytomata fit
    mdl_full = fitlm(X_train, Y_train);
    
    % Provlepsi sto Test set
    Y_pred_full = predict(mdl_full, X_test);
    
    % Ypologismos MSE
    mse_full = mean((Y_test - Y_pred_full).^2);
    
    
    %  2. PCR 
    % Vima A: Typopoiisi  twn X
    [X_train_std, mu, sigma] = zscore(X_train);
    
    % Efarmogi idias typopoiisis sto Test set 
    X_test_std = (X_test - mu) ./ sigma;
    
    % Vima B: PCA sta dedomena ekpaideusis
    [coeff, score_train, latent, ~, explained] = pca(X_train_std);
    
    % Vima C: Epilogi plithous synistwswn (Kritirio: >90% variance)
    % Athroizoume ta pososta mexri na ftasoume to 90% h 95%
    cum_var = cumsum(explained);
    n_components = find(cum_var >= 90, 1);
    if isempty(n_components)
        n_components = size(X_train, 2); % An den ftanei, krata ta ola
    end
    
    % Vima D: Palindromisi panw sta Scores 
    % Xrisimopoioume tis prwtes n_components stiles tou score_train
    % Prosthetoume stili me 1 gia to intercept (h regress to thelei)
    X_pcr_train = [ones(size(score_train,1),1), score_train(:, 1:n_components)];
    beta_pcr = regress(Y_train, X_pcr_train);
    
    % Vima E: Provlepsi sto Test Set
    % Metatropi tou X_test se Scores vasika me tous idious coeff
    score_test = X_test_std * coeff;
    X_pcr_test = [ones(size(score_test,1),1), score_test(:, 1:n_components)];
    
    Y_pred_pcr = X_pcr_test * beta_pcr;
    mse_pcr = mean((Y_test - Y_pred_pcr).^2);
    
    
    % --- 3. LASSO REGRESSION ---
    % Vima A: Euresi veltistou Lambda me Cross-Validation 
    % H lasso() thelei X, Y kai kanei moni tis standardize an to orisoume, 
    % alla edw dinoume ta raw afou exei diki ths parametro.
    [B, FitInfo] = lasso(X_train, Y_train, 'CV', 5);
    
    % Vima B: Epilogi Lambda me to elaxisto MSE
    idx_lambda = FitInfo.IndexMinMSE;
    intercept_lasso = FitInfo.Intercept(idx_lambda);
    coef_lasso = B(:, idx_lambda);
    
    % Vima C: Provlepsi
    Y_pred_lasso = X_test * coef_lasso + intercept_lasso;
    mse_lasso = mean((Y_test - Y_pred_lasso).^2);

end
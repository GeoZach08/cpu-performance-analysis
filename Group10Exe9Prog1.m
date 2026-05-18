% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

clc; clearvars; close all;

% Diabasma Dedomenwn
data = readmatrix("CPUperformance.xlsx", 'Range', 'A2');

% Dhmioyrgia teble gia olo to deigma
T_all = table(data(:,3), data(:,4), data(:,5), data(:,6), data(:,7), data(:,8), data(:,9), ...
    'VariableNames', {'MYCT', 'MMIN', 'MMAX', 'CACH', 'CHMIN', 'CHMAX', 'PRP'});

% Tyxaia Epilogh 50 parathrhsewn
n = 50;
N = size(T_all, 1);
indices = datasample(1:N, n, 'Replace', false);
T_sample = T_all(indices, :);

% Prosarmogh Modelwn (Full vs Stepwise)
% Gia olo to deigma (N = 209)
mdl_all_full = fitlm(T_all, 'PRP ~ MYCT + MMIN + MMAX + CACH + CHMIN + CHMAX');
mdl_all_step = stepwiselm(T_all, 'PRP ~ MYCT + MMIN + MMAX + CACH + CHMIN + CHMAX');

% Gia tis 50 parathrhseis
mdl_sample_full = fitlm(T_sample, 'PRP ~ MYCT + MMIN + MMAX + CACH + CHMIN + CHMAX');
mdl_sample_step = stepwiselm(T_sample, 'PRP ~ MYCT + MMIN + MMAX + CACH + CHMIN + CHMAX');

% Apotelesmata
fprintf('\n================ ΣΥΓΚΡΙΣΗ ΓΙΑ ΤΙΣ 209 ΠΑΡΑΤΗΡΗΣΕΙΣ ================\n');
fprintf('Full Model: R2 = %.4f, Adj-R2 = %.4f, MSE (Διασπορά) = %.2f\n', ...
    mdl_all_full.Rsquared.Ordinary, mdl_all_full.Rsquared.Adjusted, mdl_all_full.MSE);
fprintf('Stepwise:   R2 = %.4f, Adj-R2 = %.4f, MSE (Διασπορά) = %.2f\n', ...
    mdl_all_step.Rsquared.Ordinary, mdl_all_step.Rsquared.Adjusted, mdl_all_step.MSE);
fprintf('Επιλεγμένες Μεταβλητές Stepwise (209): %s\n', mdl_all_step.Formula);

fprintf('\n================ ΣΥΓΚΡΙΣΗ ΓΙΑ ΤΙΣ 50 ΠΑΡΑΤΗΡΗΣΕΙΣ =================\n');
fprintf('Full Model: R2 = %.4f, Adj-R2 = %.4f, MSE (Διασπορά) = %.2f\n', ...
    mdl_sample_full.Rsquared.Ordinary, mdl_sample_full.Rsquared.Adjusted, mdl_sample_full.MSE);
fprintf('Stepwise:   R2 = %.4f, Adj-R2 = %.4f, MSE (Διασπορά) = %.2f\n', ...
    mdl_sample_step.Rsquared.Ordinary, mdl_sample_step.Rsquared.Adjusted, mdl_sample_step.MSE);
fprintf('Επιλεγμένες Μεταβλητές Stepwise (50): %s\n', mdl_sample_step.Formula);

% Elegxos omoiothtas metablhtwn
vars_209 = sort(mdl_all_step.VariableNames);
vars_50 = sort(mdl_sample_step.VariableNames);

fprintf('\n================ ΣΥΜΠΕΡΑΣΜΑΤΑ ΑΝΑΛΥΣΗΣ =================\n');
if isequal(vars_209, vars_50)
    fprintf('ΑΠΑΝΤΗΣΗ: Οι επιλεγμένες μεταβλητές είναι ΙΔΙΕΣ και στα δύο δείγματα.\n');
else
    fprintf('ΑΠΑΝΤΗΣΗ: Οι μεταβλητές ΔΙΑΦΕΡΟΥΝ. Η βηματική μέθοδος επηρεάζεται από το μέγεθος του δείγματος.\n');
end

% Grafhmata Kataloipwn
figure('Name', 'Ανάλυση Καταλοίπων (Residuals Analysis)');

subplot(2,1,1);
plotResiduals(mdl_all_step, 'fitted');
title('Residuals vs Fitted (209 Observations)');
grid on;

subplot(2,1,2);
plotResiduals(mdl_sample_step, 'fitted');
title('Residuals vs Fitted (50 Observations)');
grid on;

fprintf('\n================ ΣΤΑΤΙΣΤΙΚΗ ΕΡΜΗΝΕΙΑ =================\n');

% Ermhneia adjR2
if mdl_all_step.Rsquared.Adjusted >= mdl_all_full.Rsquared.Adjusted
    fprintf('1. ΠΡΟΣΑΡΜΟΓΗ: Το Stepwise μοντέλο (209) πέτυχε ίσο ή καλύτερο Adjusted R2 (%.4f).\n', mdl_all_step.Rsquared.Adjusted);
    fprintf('   Αυτό σημαίνει ότι η αφαίρεση των μη σημαντικών μεταβλητών βελτίωσε την ποιότητα του μοντέλου.\n');
else
    fprintf('1. ΠΡΟΣΑΡΜΟΓΗ: Το πλήρες μοντέλο υπερτερεί ελαφρώς, αλλά το Stepwise είναι πιο απλό.\n');
end

% Ermhneia MSE (diaspora)
if mdl_all_step.MSE <= mdl_all_full.MSE
    fprintf('2. ΔΙΑΣΠΟΡΑ: Η διασπορά των σφαλμάτων (MSE) μειώθηκε στο Stepwise μοντέλο (%.2f).\n', mdl_all_step.MSE);
    fprintf('   Η μείωση της διασποράς υποδηλώνει ακριβέστερες προβλέψεις.\n');
end

% Sygkrish N = 50 vs N = 209
vars_209 = sort(mdl_all_step.PredictorNames);
vars_50  = sort(mdl_sample_step.PredictorNames);;

if isequal(vars_209, vars_50)
    fprintf('3. ΣΤΑΘΕΡΟΤΗΤΑ: Οι επιλεγμένες μεταβλητές είναι ΙΔΙΕΣ και στα δύο δείγματα.\n');
    fprintf('   Αυτό δείχνει ότι οι συγκεκριμένοι δείκτες είναι πολύ ισχυροί προγνωστικοί παράγοντες.\n');
else
    fprintf('3. ΣΤΑΘΕΡΟΤΗΤΑ: Οι επιλεγμένες μεταβλητές ΔΙΑΦΕΡΟΥΝ μεταξύ των 50 και 209 παρατηρήσεων.\n');
    fprintf('   Αυτό οφείλεται στο γεγονός ότι το μικρό δείγμα (50) μπορεί να μην περιλαμβάνει \n');
    fprintf('   όλη τη διακύμανση του πληθυσμού ή να επηρεάζεται από ακραίες τιμές (outliers).\n');
end

% Geniko Sxolio
fprintf('\n4. ΓΕΝΙΚΟ ΣΥΜΠΕΡΑΣΜΑ:\n');
fprintf('   Η βηματική παλινδρόμηση βοηθά στην αποφυγή του "overfitting", κρατώντας μόνο\n');
fprintf('   τις μεταβλητές που πραγματικά επηρεάζουν την απόδοση PRP του Η/Υ.\n');
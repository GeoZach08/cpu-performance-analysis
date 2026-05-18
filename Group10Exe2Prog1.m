% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

clc; clear vars; close all;
% Arxikopoihsh metablhtwn
M = 100;
n = 40;
a = 0.05;
idx_vals = [3,5,7]; % 3: MYCT, 5:MMAX, 7:CHMIN
data_raw = readmatrix("CPUperformance.xlsx", 'Range', 'A2');
% Pairnw dedomena mono apo thn deyterh grammh toy arxeioy gia na mhn exw
% problhmata me thn prwth, h opoia den einai arithmoi

% Prwto Erwthma (xwris log)
p_val_hist = zeros(M,length(idx_vals));
% Arxikopoihsh pinaka me tis times twn p gia kathe peirama
for i = 1:M
    for j=1:3
        % H synarthsh Group10Exe2Fun1 xrhsimopoiei ton elegxo chi2gof
        p_valj = Group10Exe2Fun1(data_raw, n, idx_vals(j));
        p_val_hist(i, j) = p_valj;
    end
end
accept_rate = 100 * mean(p_val_hist > a); 
fprintf('--- ΕΛΕΓΧΟΣ ΚΑΝΟΝΙΚΟΤΗΤΑΣ (Χωρίς Log) ---\n');
fprintf('Για κάθε δείκτη το ποσοστό που η υπόθεση της κανονικής κατανομής μπορεί να γίνει αποδεκτή είναι αντίστοιχα: [%.2f%%, %.2f%%, %.2f%%]\n\n', ...
    accept_rate(1), accept_rate(2), accept_rate(3));

% Deytero Ervthma (me log)
data_log = log(data_raw + eps);
% Bazw +eps gia na apofygw log(0) -> aprosdioristia
log_p_val_hist = zeros(M, length(idx_vals));
for i = 1:M
    for j=1:3
        p_valj = Group10Exe2Fun1(data_log, n, idx_vals(j));
        log_p_val_hist(i, j) = p_valj;
    end
end
accept_rate_log = 100 * mean(log_p_val_hist > a); 
fprintf('--- ΕΛΕΓΧΟΣ ΚΑΝΟΝΙΚΟΤΗΤΑΣ (Με Log) ---\n');
fprintf('Για κάθε δείκτη το ποσοστό που η υπόθεση της κανονικής κατανομής μπορεί να γίνει αποδεκτή είναι αντίστοιχα: [%.2f%%, %.2f%%, %.2f%%]\n', ...
    accept_rate_log(1), accept_rate_log(2), accept_rate_log(3));

%% Optikopoihsh
names = {'MYCT', 'MMAX', 'CHMIN'};
idx_plot = [3, 5, 7];
figure('Name', 'Ανάλυση Κατανομών: Πριν και Μετά το Log');
for i = 1:3
    % Xrhsimopoiw ta data_raw gia na mhn einai diplo-logarithmhmena
    current_data = data_raw(:, idx_plot(i));
    
    % Histogram Arxikwn Dedomenwn
    subplot(3, 2, 2*i-1);
    histogram(current_data, 15, 'FaceColor', '#0072BD');
    grid on;
    title(['Αρχικά: ', names{i}]);
    if i == 3, xlabel('Τιμές'); end
    ylabel('Συχνότητα');
    
    % Histogram Log Dedomenwn
    subplot(3, 2, 2*i);
    histogram(log(current_data + eps), 15, 'FaceColor', '#D95319');
    grid on;
    title(['Log-transformed: ', names{i}]);
    if i == 3, xlabel('log(Τιμές)'); end
end

%% Symperasmata
fprintf("\n--- ΣΥΜΠΕΡΑΣΜΑΤΑ ---\n")
fprintf("Από τα ιστογράμματα και από την ποσοστιαία μελέτη αποδοχής της μηδενικής υπόθεσης προκύπτει ότι: \n");
fprintf("Για τον πρώτο δείκτη (MYCT) το ποσοστό επιτυχίας είναι σημαντικά μεγαλύτερο στην περίπτωση του λογαρίθμου," + ...
    " για τον δεύτερο (MMAX) κατά μέσο όρο σταθερό και λίγο χειρότερο για τον τρίτο (CHMIN)");
fprintf("\n\nΑυτό οφείλεται στην κλίμακα των μεγεθών. Ο λογάριθμος λειτουργεί σαν πλάτιασμα των τιμών.\n" + ...
    "Δηλαδή συμπιέζονται οι μεγάλες τιμές και μικραίνουν οι αποστάσεις μεταξύ των μικρών.\n" + ...
    "Σε συνδυασμό με την κλίμακα του κάθε μεγέθους τα αποτελέσματα είναι αναμενόμενα.\n" + ...
    "Πιο συγκεκριμένα το MYCT παίρνει τιμές στο [38,480], ο MMAX στο [1000,32000] και ο CHMIN στο [1,16]\n");

fprintf("\nΠαρατήρηση: Σε πολλές ασκήσεις από εδώ και πέρα κατά την ανάλυση των αποτελεσμάτων " + ...
    "όταν γράφω <προκύπτει ότι>, στην πραγματικότητα εννοώ <προκύπτει χωρίς βλάβη " + ...
    "της γενικότητας ότι>.\nΔηλαδή έχοντας τρέξει το πρόγραμμα αρκετές φορές " + ...
    "τα αποτελέσματα προέκυψαν έτσι όπως παρουσιάζεται στην ανάλυση στην πλειονότητα " + ...
    "των περιπτώσεων.\nΑυτό δεν σημαίνει όμως ότι μπορούμε να αποκλείσουμε ότι " + ...
    "θα συμβεί κάτι άλλο.\nΗ παραπάνω παρατήρηση ισχύει για όλες τις ασκήσεις.\n");
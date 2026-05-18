% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

clc; clear vars; close all;
% Arxikopoihsh metablhtwn
M = 100;
n = 40;
a = 0.05;
idx_vals = [3,5,7]; % 3: MYCT, 5:MMAX, 7:CHMIN
data = readmatrix("CPUperformance.xlsx", 'Range', 'A2');

% Prwto Erwthma (xwris log)
p_val_hist = zeros(M,length(idx_vals));
for i = 1:M
    for j=1:3
        p_valj = Group10Exe3Fun1(data, n, idx_vals(j));
        p_val_hist(i, j) = p_valj;
    end
end
accept_rate = 100 * mean(p_val_hist > a); 
fprintf('--- ΕΛΕΓΧΟΣ ΑΝΤΙΠΡΟΣΩΠΕΥΤΙΚΟΤΗΤΑΣ (Χωρίς Log) ---\n');
fprintf('Ποσοστό πειραμάτων όπου το δείγμα n=40 ακολουθεί την κατανομή του μεγάλου δείγματος N=209:\n');
fprintf('Δείκτες [3, 5, 7]: [%.2f%%, %.2f%%, %.2f%%]\n\n', accept_rate(1), accept_rate(2), accept_rate(3));

% Deytero Ervthma (me log)
data_log = log(data+eps); % parolo poy exoyme +eps tha exoyme pali kai arnhtikes times gia times -> 0
log_p_val_hist = zeros(M, length(idx_vals));
for i = 1:M
    for j=1:3
        p_valj = Group10Exe3Fun1(data_log, n, idx_vals(j));
        log_p_val_hist(i, j) = p_valj;
    end
end
accept_rate = 100 * mean(log_p_val_hist > a); 
fprintf('--- ΕΛΕΓΧΟΣ ΑΝΤΙΠΡΟΣΩΠΕΥΤΙΚΟΤΗΤΑΣ (Με Log) ---\n');
fprintf('Ποσοστό πειραμάτων όπου το λογαριθμημένο δείγμα αντιπροσωπεύει τον λογαριθμημένο πληθυσμό:\n');
fprintf('Δείκτες [3, 5, 7]: [%.2f%%, %.2f%%, %.2f%%]\n', accept_rate(1), accept_rate(2), accept_rate(3));

% Optikopoihsh
names = {'MYCT', 'MMAX', 'CHMIN'};
idx_plot = [3, 5, 7];
figure('Name', 'Ανάλυση Κατανομών: Πριν και Μετά το Log');
for i = 1:3
    current_data = data(:, idx_plot(i));
    
    subplot(3, 2, 2*i-1); % subplots me sthlh 1 (deiktes 1,3,5 giayto 2i-1) ta mh-log kai sthlh 2 ta log dedomena
    histogram(current_data, 15, 'FaceColor', '#0072BD');
    grid on;
    title(['Αρχικά: ', names{i}]);
    if i == 3, xlabel('Τιμές'); end
    ylabel('Συχνότητα');

    subplot(3, 2, 2*i);
    histogram(real(log(current_data + eps)), 15, 'FaceColor', '#D95319');
    grid on;
    title(['Log-transformed: ', names{i}]);
    if i == 3, xlabel('log(Τιμές)'); end
end
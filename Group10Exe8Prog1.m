% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

clc; clearvars; close all;

% Diabasma Dedomenwn
data = readmatrix("CPUperformance.xlsx", 'Range', 'A2');
MYCT_all = data(:, 3);
PRP_all = data(:, 9);

% Tyxaia Epilogh
n = 50;
N = size(data, 1); 
indices = datasample(1:N, n, 'Replace', false); 

% Deigma twn 50 parathrhsewn
MYCT_sample = MYCT_all(indices);
PRP_sample = PRP_all(indices);

% Scatter Plot twn dedomenwn gia na exoyme mia prwth eikona
figure();
scatter(MYCT_sample, PRP_sample, 'filled');
xlabel('MYCT (Machine Cycle Time)');
ylabel('PRP (Performance)');
title('Σχέση PRP και MYCT (Δείγμα 50)');
grid on;

fprintf(" \n------- ΣΧΟΛΙΑ -------\n");
fprintf("Παρατήρηση: Η καμπύλη που ακολουθούν τα δεδομένα μας φαίνεται να είναι " + ...
    "με συνέπεια ΜΗ γραμμική και στην πλειονότητα των περιπτώσεων υπερβολή (ή " + ...
    "καλύτερα, εκθετική)");
fprintf("\nΠαρόλα αυτά για λόγους πληρότητας θα γίνει και δοκιμή γραμμικού " + ...
    "μοντέλου παλινδρόμησης.");
fprintf("\nΗ διαδικασία που θα ακολουθήσω έχει ως εξής: Διαλέγω μοντέλο " + ...
    "παλινδρόμησης (απλό γραμμικό, μη γραμμικό, ...).\nΜέσω διαγνωστικόυ ελέγχου " + ...
    "" + ...
    "βρίσκω τα (τυποποιημένα) υπόλοιπα. Κάνω το scatter plot τους και συμπαιρένουμε " + ...
    "καταλληλότητα.\nΑν αυτό το διάγραμμα είναι τυχαίο τότε το μοντέλο είναι κατάλληλο.\n");

% ------- PALINDROMHSH ------- 
n = length(MYCT_sample);

% --- Modelo 1: Grammiko ---
p1 = polyfit(MYCT_sample, PRP_sample, 1);
y_est1 = polyval(p1, MYCT_sample);

% --- Modelo 2: Logarithmiko ---
p2 = polyfit(log10(MYCT_sample), log10(PRP_sample), 1);
y_est2 = 10.^polyval(p2, log10(MYCT_sample));

% --- Modelo 3: Polywnymiko 3oy Bathmoy ---
p3 = polyfit(MYCT_sample, PRP_sample, 3);
y_est3 = polyval(p3, MYCT_sample); 

% R2 kai adj(R2)
SStot = sum((PRP_sample - mean(PRP_sample)).^2);

% Synarthsh ypologismoy R2 kai adj(R2) (gia eykolia)
calc_r2 = @(y, y_est, k) deal(1 - sum((y-y_est).^2)/SStot, ...
    1 - ((1 - (1 - sum((y-y_est).^2)/SStot)) * (n-1) / (n-k-1)));

[R2_1, adjR2_1] = calc_r2(PRP_sample, y_est1, 1);
[R2_2, adjR2_2] = calc_r2(PRP_sample, y_est2, 1);
[R2_3, adjR2_3] = calc_r2(PRP_sample, y_est3, 3);
fprintf("\n");
fprintf('Μοντέλο      |   R^2   | Adj R^2\n');
fprintf('-------------------------------\n');
fprintf('Γραμμικό     | %.4f  | %.4f\n', R2_1, adjR2_1);
fprintf('Λογαριθμικό  | %.4f  | %.4f\n', R2_2, adjR2_2);
fprintf('Πολυώνυμο 3  | %.4f  | %.4f\n', R2_3, adjR2_3);

% ------- Optikopoihsh (Scatter Plot) -------
x_fit = linspace(min(MYCT_sample), max(MYCT_sample), 200);
figure('Name', 'Σύγκριση Μοντέλων');
scatter(MYCT_sample, PRP_sample, 40, 'white', 'filled', 'MarkerFaceAlpha', 0.5);
hold on;
plot(x_fit, polyval(p1, x_fit), 'r', 'LineWidth', 2);
plot(x_fit, 10.^polyval(p2, log10(x_fit)), 'b', 'LineWidth', 2);
plot(x_fit, polyval(p3, x_fit), 'g', 'LineWidth', 2);
grid on;
xlabel('MYCT'); ylabel('PRP');
legend('Δείγμα 50', 'Γραμμικό', 'Λογαριθμικό', 'Πολυώνυμο 3ου');
title('Προσαρμογή Μοντέλων Παλινδρόμησης');

% ------- Diagnwstikos Elegxos -------
figure('Name', 'Residual Analysis');

% Ypoloipa Grammikoy
subplot(1,3,1);
res1 = (PRP_sample - y_est1) / std(PRP_sample - y_est1);
scatter(y_est1, res1, 'filled', 'MarkerFaceColor', 'r');
yline(0, '--w'); title('Υπόλοιπα: Γραμμικό'); grid on;

% Ypoloipa Logarithmikoy
subplot(1,3,2);
res2 = (PRP_sample - y_est2) / std(PRP_sample - y_est2);
scatter(y_est2, res2, 'filled', 'MarkerFaceColor', 'b');
yline(0, '--w'); title('Υπόλοιπα: Λογαριθμικό'); grid on;

% Ypoloipa Polywnymikoy
subplot(1,3,3);
res3 = (PRP_sample - y_est3) / std(PRP_sample - y_est3);
scatter(y_est3, res3, 'filled', 'MarkerFaceColor', 'g');
yline(0, '--w'); title('Υπόλοιπα: Πολυώνυμο 3'); grid on;

% ======= EPANALHPSH GIA OLA TA DEDOMENA (N = 209) =======

% --- Modela Palindromishs ---
p1_all = polyfit(MYCT_all, PRP_all, 1);           % Grammiko
p2_all = polyfit(log10(MYCT_all), log10(PRP_all), 1); % Logarithmiko
p3_all = polyfit(MYCT_all, PRP_all, 3);           % Polywnymo 3oy Bathmoy

% --- Ypologismos Ektimhsewn (y_est) ---
y_est1_all = polyval(p1_all, MYCT_all);
y_est2_all = 10.^polyval(p2_all, log10(MYCT_all));
y_est3_all = polyval(p3_all, MYCT_all);

% --- R2 kai adjR2 ---
SStot_all = sum((PRP_all - mean(PRP_all)).^2);
n_all = length(PRP_all);

% Inline Synarthsh gia adjR2: 1 - [(1-R2)*(n-1)/(n-k-1)] (xarin eykolias)
calc_adjR2 = @(y, y_est, k) 1 - ((1 - (1 - sum((y-y_est).^2)/SStot_all)) * (n_all-1) / (n_all-k-1));

R2_1_all = 1 - sum((PRP_all - y_est1_all).^2)/SStot_all;
R2_2_all = 1 - sum((PRP_all - y_est2_all).^2)/SStot_all;
R2_3_all = 1 - sum((PRP_all - y_est3_all).^2)/SStot_all;

adjR2_1_all = calc_adjR2(PRP_all, y_est1_all, 1);
adjR2_2_all = calc_adjR2(PRP_all, y_est2_all, 1);
adjR2_3_all = calc_adjR2(PRP_all, y_est3_all, 3);

% --- Sygkritika Apotelesmata ---
fprintf('\n======= ΑΠΟΤΕΛΕΣΜΑΤΑ ΓΙΑ ΟΛΑ ΤΑ ΔΕΔΟΜΕΝΑ (N=209) =======\n');
fprintf('Μοντέλο      |   R^2   | Adj R^2\n');
fprintf('-------------------------------\n');
fprintf('Γραμμικό     | %.4f  | %.4f\n', R2_1_all, adjR2_1_all);
fprintf('Λογαριθμικό  | %.4f  | %.4f\n', R2_2_all, adjR2_2_all);
fprintf('Πολυώνυμο 3  | %.4f  | %.4f\n', R2_3_all, adjR2_3_all);

% --- Diagramma Ypoloipwn ---
figure('Name', 'Residual Analysis - Total Data (N=209)');
subplot(1,3,1);
res1_all = (PRP_all - y_est1_all) / std(PRP_all - y_est1_all);
scatter(y_est1_all, res1_all, 'r'); 
yline(0, '--w'); title('Υπόλοιπα: Γραμμικό (All)');

subplot(1,3,2);
res2_all = (PRP_all - y_est2_all) / std(PRP_all - y_est2_all);
scatter(y_est2_all, res2_all, 'b'); 
yline(0, '--w'); 
title('Υπόλοιπα: Λογαριθμικό (All)');

subplot(1,3,3);
res3_all = (PRP_all - y_est3_all) / std(PRP_all - y_est3_all);
scatter(y_est3_all, res3_all, 'g'); 
yline(0, '--w'); 
title('Υπόλοιπα: Πολυώνυμο 3 (All)');

% ------- APOTELESMATA -------
fprintf("\n------- ΤΕΛΙΚΟ ΣΥΜΠΕΡΑΣΜΑ -------\n");
fprintf("Το Γραμμικό Μοντέλο απορρίπτεται λόγω χαμηλού R2 (%.2f%%) και μη τυχαίας κατανομής υπολοίπων.\n", 100*R2_1_all);

fprintf("Το Λογαριθμικό και το Πολυωνυμικό 3ου βαθμού παρουσιάζουν παρόμοια ερμηνευτική ικανότητα (Adj. R2 = %.4f).\n", adjR2_2_all);

fprintf("Ωστόσο, το λογαριθμικό μοντέλο κρίνεται ως το καταλληλότερο διότι:\n");
fprintf("1. Είναι απλούστερο μαθηματικά (λιγότερες παράμετροι).\n");
fprintf("2. Αποφεύγει τις απότομες διακυμάνσεις (overfitting) του πολυωνυμικού στις ακραίες τιμές.\n");
fprintf("3. Τα τυποποιημένα υπόλοιπά του εμφανίζουν πιο ομοιόμορφη διασπορά γύρω από το μηδέν.\n");

fprintf('\n3. ΣΥΓΚΡΙΣΗ ΔΕΙΓΜΑΤΟΣ (n=50) ΚΑΙ ΠΛΗΘΥΣΜΟΥ (N=209):\n');
fprintf('----------------------------------------------------------\n');
fprintf('Οι διαφορές μεταξύ των δύο μοντέλων (50 vs 209) είναι μικρές, γεγονός που\n');
fprintf('υποδηλώνει ότι το τυχαίο δείγμα των 50 ήταν αντιπροσωπευτικό του συνόλου.\n');
fprintf('Συγκεκριμένα, το Adj. R2 του Λογαριθμικού στο δείγμα ήταν %.4f έναντι %.4f στο σύνολο.\n', adjR2_2, adjR2_2_all);

fprintf('\n4. ΤΕΛΙΚΟ ΣΥΜΠΕΡΑΣΜΑ:\n');
fprintf('----------------------------------------------------------\n');
fprintf('Το μοντέλο των N=209 δεδομένων θεωρείται πιο αξιόπιστο για γενίκευση,\n');
fprintf('καθώς ελαχιστοποιεί την επίδραση τυχαίων διακυμάνσεων (θορύβου) του δείγματος.\n');
fprintf('Το Λογαριθμικό μοντέλο στο σύνολο των δεδομένων (N=209) αποτελεί την \n');
fprintf('πλέον ακριβή περιγραφή της εξάρτησης της απόδοσης PRP από το δείκτη MYCT.\n');
fprintf('==========================================================\n');
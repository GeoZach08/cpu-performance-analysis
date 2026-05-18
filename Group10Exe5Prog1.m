% Group 10: Chortis Eleftherios - 11106, Zacharioydakhs Gewrgios - 10938

clc; clearvars; close all;

epanalhpseis = 10;
% Diavasma dedomenwn apo to Excel (xwris titlous)
data = readmatrix("CPUperformance.xlsx", 'Range', 'A2');

% Sthlh 1: kwdikos kataskeyasth
% Sthlh 9: apodosh PRP
manufacturer = data(:,1);
PRP = data(:,9);

% Afairw tis kenes times (NaN) apo tous kataskeyastes
valid_man = manufacturer(~isnan(manufacturer));

% Vriskw tous diaforetikous kataskeyastes
% To apotelesma tha einai panta ena dianysma sthlhs me 12 theseis me times
% apo to 1 ews to 12
unique_man = unique(valid_man);

for i = 1:epanalhpseis

    % Epilogh tyxaia 2 kataskeyastwn (xwris epanathesh)
    selected_man = datasample(unique_man, 2, 'Replace', false);

    % Krataw oles tis grammes pou anhkoun stous 2 epilegmenous kataskeyastes
    % Dhmioyrgia logikoy deikth (true -> 1 gia tis parathrhseis poy anhkoyn se enan
    % apo toys dyo epilegmenoys kataskeyastes)
    idx = (manufacturer == selected_man(1)) | ...
        (manufacturer == selected_man(2));

    % Dyo deigmata PRP me logixal indexing
    % Den pairnei thn timh toy idx alla briskei tis monades (1) kai pairnei
    % aytes tis theseis diathrwntas thn swsth antistoixhsh metajy kataseyasth
    % kai PRP
    PRP_sel = PRP(idx);
    man_sel = manufacturer(idx);

    % ------- Boxplots ------- 
    figure;
    boxplot(PRP_sel, man_sel);
    xticklabels({['Manufacturer ', num2str(selected_man(1))], ['Manufacturer ', num2str(selected_man(2))]});ylabel('Apodosh PRP');
    title('Σύγκριση απόδοσης PRP για δύο τυχαίους κατασκευαστές');
    grid on;

    % ------- X2 elegxos se kanonikh katanomh -------
    % Exoyme dyo kataskeyastes, toys selected_man(1) kai selected_man(2). Pali me
    % logikh prajh jexwrizw ta deigmata gia na melethsw to kathena jexwrista, opws prin. H
    % chi2gof den anagnwrzei oti to PRP_sel prokyptei apo 2 deigmata opws
    % parapanw
    PRP1 = PRP_sel(man_sel == selected_man(1));
    PRP2 = PRP_sel(man_sel == selected_man(2));

    [h1,p1] = chi2gof(PRP1);
    [h2,p2] = chi2gof(PRP2);

    % Symperasmata elegxoy
    % h = 0: Dexomaste H0
    % h = 1: Aporriptoyme H0
    fprintf("\n------- X2 Test Επανάληψη %d -------\n", i);
    fprintf('Αποτελέσματα ελέγχου χ2 για τον κατασκευαστή %s: h = %d, p = %.4f\n', num2str(selected_man(1)), h1, p1);
    fprintf('Αποτελέσματα ελέγχου χ2 για τον κατασκευαστή %s: h = %d, p = %.4f\n', num2str(selected_man(2)), h2, p2);

    % ------- Diasthma Empistosynhs -------
    fprintf("\n------- Confidence Interval for the mean value difference Επανάληψη %d-------\n", i);
    a = 0.05; 
    bootNum = 1000; % Deigmata Bootstrap
    if (h1 == 0 && h2 ==0)
        % Parametriko Diasthma Empistosynhs
        [h, p, param_ci] = ttest2(PRP1, PRP2, 'Alpha',a);
        fprintf("Παραμετρικό 95%% διάστημα εμπιστοσύνης για την διαφορά της μέσης " + ...
            "τιμής των αποδόσεων PRP των κατασκευαστών %d και %d: [%f, %f]\n", selected_man(1), selected_man(2), param_ci(1), param_ci(2));
    else
        % H entolh bootci poy tha xrhsimopoihsw thelei san perasma function
        % handle oxi apla ta deigmata
        mean_diff = @(x1,x2) mean(x1) - mean(x2);
        % Bootstrap Diasthma Empistosynhs
        boot_ci = bootci(bootNum, {@mean_diff, PRP1, PRP2}, 'Alpha', a, 'Type', 'cper');
        % Pairnw cper typo giati einai pio katallhlos gia mh symmetrikes
        % katanomes. Afoy aporripsame thn kanonikh katanomh mallon den tha
        % yparxei symmetria
        fprintf('95%% Bootstrap CI για τη διαφορά μέσων των κατασκευαστών %d και %d: [%.4f, %.4f]\n', selected_man(1), selected_man(2), boot_ci(1), boot_ci(2));
    end
end

fprintf("\n------- Παρατηρήσεις -------\n");
fprintf("Παρατήρηση 1: Στο συγκεκριμένο πρόβλημα το κάθε δείγμα δεν είναι αρκετά μεγάλο " + ...
    "ώστε να μπορούμε να πούμε με ασφάλεια ότι τα αποτελέσματα του ελέγχου είναι αξιόπιστα.\n");
fprintf("Παρατήρηση 2: Με συνέπεια εδώ προκύπτουν p τιμές = NaN. Αυτό το πιο πιθανό " + ...
    "να οφείλεται στο μικρό δείγμα της κάθε περίπτωσης. Εδώ και τα δύο δείγματα συνήθως έχουν λιγότερες " + ...
    "από 20 παρατηρήσεις, ενώ το κάτω όριο ασφάλειας είναι n = 30.\n");
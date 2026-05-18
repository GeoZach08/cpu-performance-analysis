function [x_pdf, y_pdf] = Group10Exe1Fun1(data, n)
% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Inputs:
%   data: The vector of all observations 
%   n: The number of observations to sample
% Outputs:
%   x_pdf: The centers of the histogram bins (x-axis)
%   y_pdf: The probability density values (y-axis)

    % a) Epilogi tyxaion n paratiriseon
    % Xrisimopoioume randperm gia na paroume tyxaious deiktes
    indices = randperm(length(data), n);
    sample_data = data(indices);

    % b) Ypologismos empeirikis PDF me ti methodo tou istogrammatos
    
    % Xrisimopoioume ton kanona tou Freedman-Diaconis gia to plithos bins
    % h apla ena stathero arithmo bins gia na fainetai omoiomorfo.
    % Gia n=100, peripou sqrt(100)=10 bins einai mia kalli aytomati epilogi,
    % alla edw tha to afisoume na toypologisei h histcounts gia kalyteri
    % prosarmogi. 
    
    [counts, edges] = histcounts(sample_data, 'Normalization', 'pdf');
    
    % Ypologismos kentron twn bins gia na sxediasoume kampyli
    x_pdf = (edges(1:end-1) + edges(2:end)) / 2;
    y_pdf = counts;
    
end
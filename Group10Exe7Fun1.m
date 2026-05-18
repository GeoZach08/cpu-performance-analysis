function [rej_param, rej_rand] = Group10Exe7Fun1(x, y, alpha)
% GROUP 10: Zacharioudakis Georgios - 10938, Eleutherios Chortis - 11106
% Zhtima 7 - Function
% Inputs:
%   x, y: Ta dianysmata twn dyo metavlitwn (n paratiriseis)
%   alpha: Epipedo simantikotitas (p.x. 0.05)
% Outputs:
%   rej_param: 1 an aporriptetai h H0 me parametriko elegxo, 0 alliws
%   rej_rand: 1 an aporriptetai h H0 me elegxo tyxaiopoiisis, 0 alliws

    % 1. Parametrikos Elegxos 
    % H synartisi corr epistrefei to p-value gia H0: rho=0
    [r_obs, p_param] = corr(x, y);
    
    if p_param < alpha
        rej_param = 1;
    else
        rej_param = 0;
    end
    
    %  2. Elegxos Tyxaiopoiisis 
    n_perm = 1000; % Arithmos epanalipsewn 
    count_extreme = 0;
    
    % Kratame to apoluto r_obs gia elegxo dipleuris 
    abs_r_obs = abs(r_obs);
    
    for k = 1:n_perm
        % Anakatema  mono tou y
        y_perm = y(randperm(length(y)));
        
        % Ypologismos sysxetisis sto tyxaio zeugari
        r_rand = corr(x, y_perm);
        
        % Metrame poses fores to tyxaio r einai 'pio akraio' apo to paratiroymeno
        if abs(r_rand) >= abs_r_obs
            count_extreme = count_extreme + 1;
        end
    end
    
    % Ypologismos p-value tyxaiopoiisis
    p_rand = count_extreme / n_perm;
    
    if p_rand < alpha
        rej_rand = 1;
    else
        rej_rand = 0;
    end

end
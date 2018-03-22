function [Fk,kb,alpha,rho0,Fk_kb,Fk_alpha,Fk_rho0,kb_alpha,kb_rho0,...
    alpha_rho0] = batchparam_surfacelkhd(num_intervals,nameofsavedfile)

global time;

num = num_intervals+1;

savefile = strcat('surfacelkhd/',nameofsavedfile);

Fk = linspace(0.1,1.5,num);
kb = linspace(500,4750,num);
alpha = linspace(0.1,1,num);
rho0 = linspace(1000,4000,num);

Fkopt = (Fk(end)-Fk(1))/2;
kbopt = (kb(end)-kb(1))/2;
alphaopt = (alpha(end)-alpha(1))/2;
rho0opt = (rho0(end)-rho0(1))/2;

Fk_kb = zeros(num);
Fk_alpha = zeros(num);
Fk_rho0 = zeros(num);
kb_alpha = zeros(num);
kb_rho0 = zeros(num);
alpha_rho0 = zeros(num);

for i = 1:num
    for j = 1:num
        %%% Fk vs kb surface liklihood
        simparam.Fk = Fk(i);
        simparam.kb = kb(j);
        simparam.alpha = alphaopt;
        simparam.rho0 = rho0opt;
        [density,curve] = onelayer(simparam);

        if time.simulation_end_early==1
            Fk_kb(i,j) = 10^20;
        else
            Fk_kb(i,j) = data_errorfunction(density,curve);
        end
        
        %%% Fk vs alpha surface liklihood
        simparam.Fk = Fk(i);
        simparam.kb = kbopt;
        simparam.alpha = alpha(j);
        simparam.rho0 = rho0opt;
        [density,curve] = onelayer(simparam);
        
        if time.simulation_end_early==1
            Fk_alpha(i,j) = 10^20;
        else
            Fk_alpha(i,j) = data_errorfunction(density,curve);
        end
        
        %%% Fk vs rho0 surface liklihood
        simparam.Fk = Fk(i);
        simparam.kb = kbopt;
        simparam.alpha = alphaopt;
        simparam.rho0 = rho0(j);
        [density,curve] = onelayer(simparam);
        
        if time.simulation_end_early==1
            Fk_rho0(i,j) = 10^20;
        else
            Fk_rho0(i,j) = data_errorfunction(density,curve);
        end
        
        %%% kb vs alpha surface liklihood
        simparam.Fk = Fkopt;
        simparam.kb = kb(i);
        simparam.alpha = alpha(j);
        simparam.rho0 = rho0opt;
        [density,curve] = onelayer(simparam);
        
        if time.simulation_end_early==1
            kb_alpha(i,j) = 10^20;
        else
            kb_alpha(i,j) = data_errorfunction(density,curve);
        end
        
        %%% kb vs rho0 surface liklihood
        simparam.Fk = Fkopt;
        simparam.kb = kb(i);
        simparam.alpha = alphaopt;
        simparam.rho0 = rho0(j);
        [density,curve] = onelayer(simparam);
        
        if time.simulation_end_early==1
            kb_rho0(i,j) = 10^20;
        else
            kb_rho0(i,j) = data_errorfunction(density,curve);
        end
        
        %%% alpha vs rho0 surface liklihood
        simparam.Fk = Fkopt;
        simparam.kb = kbopt;
        simparam.alpha = alpha(i);
        simparam.rho0 = rho0(j);
        [density,curve] = onelayer(simparam);
        
        if time.simulation_end_early==1
            alpha_rho0(i,j) = 10^20;
        else
            alpha_rho0(i,j) = data_errorfunction(density,curve);
        end
    end
    
    save(savefile,'Fk','kb','alpha','rho0','Fkopt','kbopt','alphaopt',...
        'rho0opt','Fk_kb','Fk_alpha','Fk_rho0','kb_alpha','kb_rho0',...
        'alpha_rho0');
    
    disp([num2str(i/num*100),'% done'])
end

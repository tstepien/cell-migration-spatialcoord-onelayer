function [Fk,kb,alpha,rho0,Fk_kb_alpha,Fk_alpha_rho0,Fk_kb_rho0,...
    kb_alpha_rho0] = batchparam_surfacelkhd_3d(num_intervals,nameofsavedfile)

global time;

num = num_intervals+1;

savefile = strcat('surfacelkhd/',nameofsavedfile);

Fk = linspace(0.1,1.5,num);
kb = linspace(500,4750,num);
alpha = linspace(0.1,1,num);
rho0 = linspace(1000,4000,num);

Fkopt = (Fk(end)+Fk(1))/2;
kbopt = (kb(end)+kb(1))/2;
alphaopt = (alpha(end)+alpha(1))/2;
rho0opt = (rho0(end)+rho0(1))/2;

Fk_kb_alpha = zeros(num,num,num);
Fk_alpha_rho0 = zeros(num,num,num);
Fk_kb_rho0 = zeros(num,num,num);
kb_alpha_rho0 = zeros(num,num,num);

for i = 1:num
    for j = 1:num
        for k = 1:num
            %%% Fk vs kb vs alpha surface liklihood
            simparam.Fk = Fk(i);
            simparam.kb = kb(j);
            simparam.alpha = alpha(k);
            simparam.rho0 = rho0opt;
            [density,curve] = onelayer(simparam);
            
            if time.simulation_end_early==1
                Fk_kb_alpha(i,j,k) = 10^20;
            else
                Fk_kb_alpha(i,j,k) = data_errorfunction(density,curve);
            end
            
            %%% Fk vs alpha vs rho0 surface liklihood
            simparam.Fk = Fk(i);
            simparam.kb = kbopt;
            simparam.alpha = alpha(j);
            simparam.rho0 = rho0(k);
            [density,curve] = onelayer(simparam);
            
            if time.simulation_end_early==1
                Fk_alpha_rho0(i,j,k) = 10^20;
            else
                Fk_alpha_rho0(i,j,k) = data_errorfunction(density,curve);
            end
            
            %%% Fk vs kb vs rho0 surface liklihood
            simparam.Fk = Fk(i);
            simparam.kb = kb(j);
            simparam.alpha = alphaopt;
            simparam.rho0 = rho0(k);
            [density,curve] = onelayer(simparam);
            
            if time.simulation_end_early==1
                Fk_kb_rho0(i,j,k) = 10^20;
            else
                Fk_kb_rho0(i,j,k) = data_errorfunction(density,curve);
            end
            
            %%% kb vs alpha vs rho0 surface liklihood
            simparam.Fk = Fkopt;
            simparam.kb = kb(i);
            simparam.alpha = alpha(j);
            simparam.rho0 = rho0(k);
            [density,curve] = onelayer(simparam);
            
            if time.simulation_end_early==1
                kb_alpha_rho0(i,j,k) = 10^20;
            else
                kb_alpha_rho0(i,j,k) = data_errorfunction(density,curve);
            end
        end
        
        save(savefile,'Fk','kb','alpha','rho0','Fkopt','kbopt','alphaopt',...
            'rho0opt','Fk_kb_alpha','Fk_alpha_rho0','Fk_kb_rho0',...
            'kb_alpha_rho0');
        
        disp([num2str(i/num*100),'% done'])
    end
end
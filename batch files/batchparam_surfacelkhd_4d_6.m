function batchparam_surfacelkhd_4d_6(nameofsavedfile,filestring,growthfunction,...
    time,number_nodes,exp_px,exp_scale)

Fk = linspace(0.1,1.5,25);
kb = linspace(500,5000,25);
alpha = [0.2, 0.4, 0.6, 0.8, 1];
rho0 = [1000, 1500, 2000, 2500, 3000];

Fklen = length(Fk);
kblen = length(kb);
alphalen = length(alpha);
rho0len = length(rho0);
% totlen = Fklen*kblen*alphalen*rho0len;

load('indicestodo6.mat');

for ind = todo
    [ii,jj,kk,mm] = ind2sub([Fklen,kblen,alphalen,rho0len],ind);
    
    Fk = linspace(0.1,1.5,25);
    kb = linspace(500,5000,25);
    alpha = [0.2, 0.4, 0.6, 0.8, 1];
    rho0 = [1000, 1500, 2000, 2500, 3000];
    
    [density,curve,time_simulation_end_early,centerdensincrease,g] ...
        = onelayer_par([Fk(ii),kb(jj),alpha(kk),rho0(mm)],...
        filestring,growthfunction,time,number_nodes,exp_px,exp_scale);
    
    if time_simulation_end_early==1
        err_dist = NaN;
        err_densratios = NaN;
    else
        [err_dist,err_densratios] = data_errorfunction_split(density,curve,exp_scale,filestring,g);
    end
    
    savefile = strcat('surfacelkhd/',nameofsavedfile,'/',num2str(ind),'.mat');
    
    parsave(savefile,[ii,jj,kk,mm,Fk(ii),kb(jj),alpha(kk),rho0(mm),...
        err_dist,err_densratios,centerdensincrease]);
end

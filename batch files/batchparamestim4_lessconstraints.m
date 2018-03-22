function [param_new,min_quantity,exitflag] = batchparamestim4_lessconstraints(Fk,kb,alpha,rho0,nameofsavedfile)

options = optimset('MaxIter',1000,'Display','iter');

L = length(Fk)*length(kb)*length(alpha)*length(rho0);

param_guess = zeros(L,4);
param_new = zeros(L,4);
min_quantity = zeros(L,1);
exitflag = zeros(L,1);

s = 0;

for i = 1:length(Fk)
    for j = 1:length(kb)
        for n = 1:length(alpha)
            for p = 1:length(rho0)
                s = s + 1;
                param.Fk = Fk(i);
                param.kb = kb(j);
                param.alpha = alpha(n);
                param.rho0 = rho0(p);
                param_guess(s,:) = [param.Fk param.kb param.alpha param.rho0];
                
                [param_new(s,:),min_quantity(s),exitflag(s)] = ...
                    fminsearch(@paramestimation4_lessconstraints,...
                    [param.Fk,param.kb,param.alpha,param.rho0],options);
                
                savefile = strcat('paramestim/',nameofsavedfile);
                save(savefile,'param_new','min_quantity','exitflag','param_guess')
            end
        end
    end
end
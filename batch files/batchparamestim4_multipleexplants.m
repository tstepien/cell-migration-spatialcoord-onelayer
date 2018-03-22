function [param_new,min_quantity,exitflag] = batchparamestim4_multipleexplants(Fk,kb,alpha,rho0,nameofsavedfile)

global allfilestrings;

numexplants = length(allfilestrings);

options = optimset('MaxIter',1000,'Display','iter');

L = length(Fk)*length(kb)*length(alpha)*length(rho0);

param_guess = zeros(L,2*numexplants+2);
param_new = zeros(L,2*numexplants+2);
min_quantity = zeros(L,1);
exitflag = zeros(L,1);

step = 0;

for i = 1:length(Fk)
    for j = 1:length(kb)
        for n = 1:length(alpha)
            for p = 1:length(rho0)
                step = step + 1;
                param.Fk = repmat(Fk(i),1,numexplants);
                param.kb = repmat(kb(j),1,numexplants);
                param.alpha = alpha(n);
                param.rho0 = rho0(p);
                param_guess(step,:) = [param.Fk param.kb param.alpha param.rho0];
                
                [param_new(step,:),min_quantity(step),exitflag(step)] = ...
                    fminsearch(@paramestimation4_multipleexplants,...
                    [param.Fk,param.kb,param.alpha,param.rho0],options);
                
                savefile = strcat('paramestim/',nameofsavedfile);
                save(savefile,'param_new','min_quantity','exitflag','param_guess')
            end
        end
    end
end
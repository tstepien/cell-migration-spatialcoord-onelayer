function [param_new,min_quantity,exitflag] = batchparamestim3(Fk,kb,alpha,rho0,nameofsavedfile)

global a;
a = alpha;

options = optimset('MaxIter',1000,'Display','iter');

L = length(Fk)*length(kb)*length(rho0);

param_guess = zeros(L,3);
param_new = zeros(L,3);
min_quantity = zeros(L,1);
exitflag = zeros(L,1);

step = 0;

for i = 1:length(Fk)
    for j = 1:length(kb)
        for n = 1:length(rho0)
            step = step + 1;
            param.Fk = Fk(i);
            param.kb = kb(j);
            param.rho0 = rho0(n);
            param_guess(step,:) = [param.Fk param.kb param.rho0];

            [param_new(step,:),min_quantity(step),exitflag(step)] = ...
                fminsearch(@paramestimation3,...
                [param.Fk,param.kb,param.rho0],options);

            savefile = strcat('paramestim/',nameofsavedfile);
            save(savefile,'param_new','min_quantity','exitflag','param_guess')
        end
    end
end
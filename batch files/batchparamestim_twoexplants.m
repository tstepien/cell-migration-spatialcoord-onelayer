function [param_new,min_quantity,exitflag] = batchparamestim_twoexplants(Fk,kb,alpha,nameofsavedfile)

options = optimset('MaxIter',1000,'Display','iter');

L = length(Fk)*length(kb)*length(alpha);

param_guess = zeros(L,5);
param_new = zeros(L,5);
min_quantity = zeros(L,1);
exitflag = zeros(L,1);

step = 0;

for i = 1:length(Fk)
    for j = 1:length(kb)
        for n = 1:length(alpha)
            step = step + 1;
            param.Fk1 = Fk(i);
            param.Fk2 = Fk(i);
            param.kb1 = kb(j);
            param.kb2 = kb(j);
            param.alpha = alpha(n);
            param_guess(step,:) = [param.Fk1 param.kb1 param.Fk2 ...
                param.kb2 param.alpha];

            [param_new(step,:),min_quantity(step),exitflag(step)] = ...
                fminsearch(@paramestimation_twoexplants,...
                [param.Fk1,param.kb1,param.Fk2,param.kb2,param.alpha],options);

            savefile = strcat('paramestim/',nameofsavedfile);
            save(savefile,'param_new','min_quantity','exitflag','param_guess')
        end
    end
end
function [param_new,min_quantity,exitflag] = batchparamestim2_fixalpha(Fk,kb,alpha,nameofsavedfile)

global a;

a = alpha;

options = optimset('MaxIter',1000,'Display','iter');

L = length(Fk)*length(kb);

param_guess = zeros(L,3);
param_new = zeros(L,2);
min_quantity = zeros(L,1);
exitflag = zeros(L,1);

step = 0;

for i = 1:length(Fk)
    for j = 1:length(kb)
        step = step + 1;
        param.Fk = Fk(i);
        param.kb = kb(j);
        param_guess(step,:) = [param.Fk param.kb alpha];
        
        [param_new(step,:),min_quantity(step),exitflag(step)] = ...
            fminsearch(@paramestimation2_fixalpha,[param.Fk,param.kb],options);
        
        savefile = strcat('paramestim/',nameofsavedfile);
        save(savefile,'param_new','min_quantity','exitflag','param_guess')
    end
end
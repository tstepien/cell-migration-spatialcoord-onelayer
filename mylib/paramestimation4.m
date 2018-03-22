function min_quantity = paramestimation4(param)
% min_quantity = paramestimation4(param)
%
% parameter estimation file that contains minimization function
%
% input:
%   param = parameters (vector with Fk,kb,alpha) - note that Fk = F/k and
%           kb = k/b due to parameter identifiability
%
% output:
%   min_quantity = the quantity that is to be minimized in the parameter
%                  estimation

global time;

% give large penalty if any parameters are negative
if param(1)<=0 || param(2)<=0 || param(3)<=0 || param(4)<=0 ...
        || param(4)>60400 ... %rho0 can't be larger than IEC-6 value
        || param(3)>1 %alpha can't be larger than 1
    min_quantity = 10^20;
    return
end

simparam.Fk = param(1);
simparam.kb = param(2);
simparam.alpha = param(3);
simparam.rho0 = param(4);

[density,curve] = onelayer(simparam);

% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end

min_quantity = data_errorfunction(density,curve);
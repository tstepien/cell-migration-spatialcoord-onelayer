function min_quantity = paramestimation2(param)
% min_quantity = paramestimation2(param)
%
% parameter estimation file that contains minimization function
%
% input:
%   param = parameters (vector with Fk,kb) - note that Fk = F/k and
%           kb = k/b due to parameter identifiability
%
% output:
%   min_quantity = the quantity that is to be minimized in the parameter
%                  estimation

global rho0 time;

% give large penalty if any parameters are negative
if param(1)<=0 || param(2)<=0
    min_quantity = 10^20;
    return
end

simparam.Fk = param(1);
simparam.kb = param(2);
simparam.alpha = 0;
simparam.rho0 = rho0;

[density,curve] = onelayer(simparam);

% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end

min_quantity = data_errorfunction(density,curve);
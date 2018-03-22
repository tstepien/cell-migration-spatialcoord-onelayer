function min_quantity = paramestimation_twoexplants(param)
% min_quantity = paramestimation_twoexplants(param)
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

global rho0 time filestring filestring1 filestring2;
global exp_px exp_px1 exp_px2;

% give large penalty if any parameters are negative
if param(1)<=0 || param(2)<=0 || param(3)<=0 || param(4)<=0 || param(5)<=0
    min_quantity = 10^20;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run through with first explant
simparam.Fk = param(1);
simparam.kb = param(2);
simparam.alpha = param(5);
simparam.rho0 = rho0;

filestring = filestring1;
exp_px = exp_px1;
[density1,curve1] = onelayer(simparam);

% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run through with second explant
simparam.Fk = param(3);
simparam.kb = param(4);
simparam.alpha = param(5);
simparam.rho0 = rho0;

filestring = filestring2;
exp_px = exp_px2;
[density2,curve2] = onelayer(simparam);

% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_quantity1 = data_errorfunction(density1,curve1);
min_quantity2 = data_errorfunction(density2,curve2);
min_quantity = (min_quantity1 + min_quantity2)/2;
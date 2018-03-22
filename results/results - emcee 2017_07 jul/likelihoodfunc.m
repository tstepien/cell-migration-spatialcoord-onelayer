function min_quantity = likelihoodfunc(param)
% min_quantity = likelihoodfunc(param)
%
% likelihood - minimization function
%
% input:
%   param = parameters (vector with Fk,kb,alpha) - note that Fk = F/k and
%           kb = k/b due to parameter identifiability
%
% output:
%   min_quantity = the quantity that is to be minimized in the parameter
%                  estimation

global time;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simparam.Fk = param(1);
simparam.kb = param(2);
simparam.alpha = param(3);
simparam.rho0 = param(4);

[density,curve] = onelayer(simparam);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if time.simulation_end_early==0
    min_quantity = data_errorfunction(density,curve);
else
    min_quantity = NaN;
end
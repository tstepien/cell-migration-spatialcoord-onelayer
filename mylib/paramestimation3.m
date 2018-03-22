function min_quantity = paramestimation3(param)
% min_quantity = paramestimation3(param)
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

global time a g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% give large penalty if any parameters are negative
if param(1)<=0 || param(2)<=0 || param(3)<=0
    min_quantity = 10^20;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simparam.Fk = param(1);
simparam.kb = param(2);
simparam.alpha = a;
simparam.rho0 = param(3);

[density,curve] = onelayer(simparam);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% give large penalty if the density (in the center) increases over time
xmid = ceil((g.Nx+1)/2);
ymid = ceil((g.Ny+1)/2);
centerdensity = zeros(length(density),1);
for i = 1:length(density)
    centerdensity(i) = density{i}(ymid,xmid);
end
if max(diff(centerdensity))>0.5
    min_quantity = 10^20;
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_quantity = data_errorfunction(density,curve);
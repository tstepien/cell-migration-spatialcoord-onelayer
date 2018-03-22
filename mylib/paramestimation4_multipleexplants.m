function min_quantity = paramestimation4_multipleexplants(param)
% min_quantity = paramestimation4_multipleexplants(param)
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

global time allfilestrings all_exp_px filestring exp_px g;
% global exp_densratio exp_boundary;

% give large penalty if any parameters are negative
if (sum(param<0) > 0) == 1
    min_quantity = 10^20;
    return
end
% for i = 1:length(param)
%     if param(i)<=0
%         min_quantity = 10^20;
%         return
%     end
% end

numexplants = length(allfilestrings);
min_quantities = zeros(numexplants,1);

simparam.alpha = param(end-1);
simparam.rho0 = param(end);

for i = 1:numexplants
    simparam.Fk = param(i);
    simparam.kb = param(numexplants+i);
    
    filestring = allfilestrings{i};
    exp_px = all_exp_px{i};
    [density,curve] = onelayer(simparam);
    
    % give large penalty if cell boundary went beyond the computational domain
    % (simulation_end_early = 1)
    if time.simulation_end_early==1
        min_quantity = 10^20;
        return
    end
    
    % give large penalty if the density (in the center) increases over time
    xmid = ceil((g.Nx+1)/2);
    ymid = ceil((g.Ny+1)/2);
    centerdensity = zeros(length(density),1);
    for j = 1:length(density)
        centerdensity(j) = density{j}(ymid,xmid);
    end
    if max(diff(centerdensity))>0.5
        min_quantity = 10^20;
        return
    end
    
    min_quantities(i) = data_errorfunction(density,curve);
end

min_quantity = sum(min_quantities)/numexplants;
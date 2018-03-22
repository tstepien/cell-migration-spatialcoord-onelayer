function min_quantity = paramestimation_kb_varies(param)
% min_quantity = paramestimation_kb_varies(param)
%
% parameter estimation file that contains minimization function
%
% input:
%   param = parameters (vector with Fk,Fk,kbintcpt,kbslope)
%        - note that Fk = F/k and kb = k/b due to parameter identifiability
%
% output:
%   min_quantity = the quantity that is to be minimized in the parameter
%                  estimation

global exp_density exp_boundary rho0 time;

% give large penalty if any parameters are negative
if param(1)<=0 || param(2)+param(3)*time.end<=0
    min_quantity = 10^20;
    return
end

simparam.Fk = param(1);
simparam.kbintcpt = param(2);
simparam.kbslope = param(3);
simparam.rho0 = rho0;

[density,curve] = onelayer_kb_varies(simparam);

% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end

L = length(exp_density);

diff_density = cell(1,L);
avgnorm_density = zeros(1,L);
diff_dist = cell(1,L);
avgnorm_dist = zeros(1,L);

for i = 1:L
    mask = exp_density{i}>0;
    diff_density{i} = abs(mask.*density{i} - simparam.rho0*exp_density{i});
    avgnorm_density(i) = norm(diff_density{i}(:));

    diff_dist{i} = find_dist_twofullcurves(curve{i},exp_boundary{i});
    avgnorm_dist(i) = norm(diff_dist{i});
end

min_quantity = sum(avgnorm_density) + sum(avgnorm_dist);
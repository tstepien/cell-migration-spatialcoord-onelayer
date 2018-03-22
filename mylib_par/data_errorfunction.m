function min_quantity = data_errorfunction(density,curve,exp_scale,filestring,g)
% min_quantity = data_errorfunction(density,curve)
%
% Calculates the error between the density ratios and the coordinates of
% the boundary of the numerical simulation and experimental data
%
% Mean-squared difference
%
% Inputs:
%   density = density from numerical simulation
%   curve = coordinates of boundary from numerical simulation
%
% Output:
%   min_quantity = calculated error

exp_densratio = prep_expdata_dens(strcat(filestring,'densratios.mat'),g);
exp_boundary = prep_expdata_bdy(strcat(filestring,'boundaries.mat'),...
    exp_scale,g);

frameIncrement = 5;

L = length(exp_densratio);

diff_densratio = cell(1,L);
avgnorm_densratio = zeros(1,L);
diff_dist = cell(1,L+frameIncrement);
avgnorm_dist = zeros(1,L+frameIncrement);

for i = 1:L
    num_densratio = density{i}./density{i+frameIncrement};
    num_densratio(isnan(num_densratio)==1) = 0; %remove 0 divided by 0
    num_densratio(isinf(num_densratio)==1) = 0; %remove divide by 0
    diff_densratio{i} = abs(num_densratio - exp_densratio{i});
    avgnorm_densratio(i) = norm(diff_densratio{i}(:)/sum(diff_densratio{i}(:)>0));
    
    diff_dist{i} = find_dist_twofullcurves(curve{i},exp_boundary{i});
    avgnorm_dist(i) = norm(diff_dist{i}/length(diff_dist{i}));
end

for i = L+1:L+frameIncrement %add in extra frames for boundaries
    diff_dist{i} = find_dist_twofullcurves(curve{i},exp_boundary{i});
    avgnorm_dist(i) = norm(diff_dist{i}/length(diff_dist{i}));
end

weight = 1000;

min_quantity = weight*sum(avgnorm_densratio(2:L)) ... % add weight on density ratio part
    + sum(avgnorm_dist(2:L+frameIncrement));
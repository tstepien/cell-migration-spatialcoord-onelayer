% function [min_quantity,err_dist,err_densratio] = ...
%     data_errorfunction_plot(density,curve)
% [min_quantity,err_dist,err_densratio] = data_errorfunction_plot(density,curve)
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
%   min_quantity  = calculated error
%   err_dist      = error from the boundaries
%   err_densratio = error from the density ratios

global exp_densratio exp_boundary exp_scale filestring;

% if isempty(exp_densratio)==1
    exp_densratio = prep_expdata_dens(strcat(filestring,'densratios.mat'));
% end
% if isempty(exp_boundary)==1
    exp_boundary = prep_expdata_bdy(strcat(filestring,'boundaries.mat'),...
        exp_scale);
% end

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

err_dist = sum(avgnorm_dist(2:L+frameIncrement));
err_densratio = sum(avgnorm_densratio(2:L));

min_quantity = weight*err_densratio + err_dist;

sum_dist = cumsum(avgnorm_dist(2:L));
sum_densratio = weight*cumsum(avgnorm_densratio(2:L));
sum_min_quantity = sum_dist + sum_densratio;

tt = plot_times(1:L-1);

plot(tt,sum_dist,tt,sum_densratio,tt,sum_min_quantity)
xlabel('time (hr)')
ylabel('cumulative error')
legend('distance error','density ratio error (with weight)','total error',...
    'Location','NorthWest')
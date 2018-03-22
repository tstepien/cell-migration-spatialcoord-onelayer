clc
clear variables global
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions
addpath emcee
addpath rmvnrnd

global time figureson number_nodes exp_px exp_scale filestring nameofsavedfile;
global growthfunction;

% location of experimental data
filestring = 'experimental_data/toyproblem/';

figureson = 1; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [440,440]; %size of experimental window in pixels
exp_scale = 1; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('toyproblem_',growthfunction);

%%% initial values for walkers (use previously calculated optimized
%%% parameter values)
%%% [F/k ; k/b ; alpha ; rho0]
mu = [0.2 ; 1000 ; 0.2 ; 2500];

param.Fk = mu(1);
param.kb = mu(2);
param.alpha = mu(3);
param.rho0 = mu(4);

[density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer(param);


exp_densratio = [];
exp_boundary = [];

min_quantity = data_errorfunction(density,curve)

global init_mass;

figure
plot(time.timewholesim(2:end),init_mass*ones(size(time.timewholesim(2:end))),'--',...
    time.timewholesim(2:end),init_mass/2*ones(size(time.timewholesim(2:end))),'--',...
    time.timewholesim(2:end),cumsum(newmassadded))
xlabel('time (hr)','FontSize',14)
ylabel('cumulative sum of mass added (cells)','FontSize',14)
set(gca,'FontSize',12)
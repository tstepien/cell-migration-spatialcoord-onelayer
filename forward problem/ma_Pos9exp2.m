clc
clear variables
close all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = '../../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos9_exp2/';

figureson = 1; %%% figures on? 1=yes, 0=no
% paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
%%%
growthfunction = 'logistic_masslimited';
param.Fk   = 0.520630240160158;
param.kb   = 2355.36879503923;
param.alpha = 0.558237037551383;
rho0 = 2702.30161205502;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [355,335]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%---------------------------------------------------------------------%%%
param.rho0 = rho0;
[density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer(param);

exp_densratio = [];
exp_boundary = [];

min_quantity = data_errorfunction(density,curve)

global init_mass;

figure
plot(time.timewholesim(2:end),init_mass*ones(size(time.timewholesim(2:end))),...
    time.timewholesim(2:end),cumsum(newmassadded))
xlabel('time (hr)','FontSize',14)
ylabel('cumulative sum of mass added (cells)','FontSize',14)
set(gca,'FontSize',12)



beep
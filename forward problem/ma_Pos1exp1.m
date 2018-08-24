clc
clear variables
close all
addpath ../
addpath ../mylib
addpath ../mylib/shapes
addpath ../mylib/growthfunctions

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = '../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos1_exp1/';

figureson = 1; %%% figures on? 1=yes, 0=no
% paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
%%%
growthfunction = 'logistic_masslimited';
%%% min value (parameters from Explant #17)
param.Fk   = 0.9329;
param.kb   = 838;
param.alpha = 0.9668;
rho0 = 1610;

%%% average value
% param.Fk   = 0.5560;
% param.kb   = 2566;
% param.alpha = 0.4411;
% rho0 = 1477;

%%% parameters from region Ia (parameters from Explant #1)
% param.Fk   = 0.6351;
% param.kb   = 507;
% param.alpha = 0.9429;
% rho0 = 1182;

%%% parameters from region Ib (parameters from Explant #8)
% param.Fk   = 0.7613;
% param.kb   = 721;
% param.alpha = 0.9786;
% rho0 = 1405;

%%% parameters from region II (parameters from Explant #14)
% param.Fk   = 0.8376;
% param.kb   = 646;
% param.alpha = 0.9474;
% rho0 = 1725;


% param.Fk   = 89/120; %0.7416
% param.kb   = 1250;
% param.alpha = 1;
% rho0 = 2500;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [542,568]; %size of experimental window in pixels
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
clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring;
global growthfunction rho0;

% location of experimental data
filestring = 'experimental_data/SizeGapData/2014_02_21/Pos6/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [989,924]; %size of experimental window in pixels
exp_scale = .366; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_fulltime';

Fk = [0.5 , 0.7 , 0.9];
kb = [1700 , 9350 , 17000];
alpha = 0.32277;
% scaling    = 10^6;
rho0 = 3734;%*scaling;

nameofsavedfile = strcat('Pos6_',growthfunction);

[param_new,min_quantity,exitflag] = ...
    batchparamestim2_fixalpha(Fk,kb,alpha,nameofsavedfile);




%%%%%%%%%%%%%%%%%%%
filestring = 'experimental_data/SizeGapData/2014_02_21/Pos7/';
exp_px = [1021,1025]; %size of experimental window in pixels
nameofsavedfile = strcat('Pos7_',growthfunction);
[param_new,min_quantity,exitflag] = ...
    batchparamestim2_fixalpha(Fk,kb,alpha,nameofsavedfile);

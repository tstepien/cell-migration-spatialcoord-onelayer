clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson rho0 number_nodes exp_scale;
global exp_px1 exp_px2 filestring1 filestring2;
global growthfunction;

% location of experimental data
filestring1 = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/';
filestring2 = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos14_exp8/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px1 = [767,848]; %size of experimental window in pixels
exp_px2 = [287,241]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
% scaling    = 10^6;
rho0 = 1000;%0.001*scaling;

growthfunction = 'exponential_fulltime';

%%%---------------------------------------------------------------------%%%
%%%---------------------------------------------------------------------%%%
%%%---------------------------------------------------------------------%%%

Fk = [0.2 , 1.2];
kb = [100 , 1000];
alpha = [0 , 0.5 , 1 , 2];

nameofsavedfile = strcat('Pos0_and_Pos14exp8_',growthfunction);

[param_new,min_quantity,exitflag] = batchparamestim_twoexplants(Fk,kb,alpha,nameofsavedfile);


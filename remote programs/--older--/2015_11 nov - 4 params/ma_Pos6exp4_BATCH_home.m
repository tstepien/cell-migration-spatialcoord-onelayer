clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = '../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos6_exp4/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [422,384]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

Fk = [0.75 , 1.5];
kb = [3750 , 7500];
alpha = [0.1 , 0.3];
% scaling    = 10^6;
rho0 = [2000 , 5000];%*scaling;

nameofsavedfile = strcat('Pos6exp4_',growthfunction);

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_lessconstraints(Fk,kb,alpha,rho0,nameofsavedfile);

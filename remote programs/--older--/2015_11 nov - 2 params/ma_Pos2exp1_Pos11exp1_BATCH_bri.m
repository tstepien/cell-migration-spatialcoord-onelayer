setenv MATLAB_DISABLE_CBWR 1
setenv MKL_CBWR AVX

clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring;
global growthfunction rho0;

% location of experimental data
filestring = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos2_exp1/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [492,504]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

Fk = [0.75 , 1.125 , 1.5];
kb = [3750 , 5625 , 7500];
alpha = 0.40243;
% scaling    = 10^6;
rho0 = 2009;%*scaling;

nameofsavedfile = strcat('Pos2exp1_',growthfunction);

[param_new,min_quantity,exitflag] = ...
    batchparamestim2_fixalpha(Fk,kb,alpha,nameofsavedfile);




%%%%%%%%%%%%%%%%%%%
filestring = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos11_exp1/';
exp_px = [209,225]; %size of experimental window in pixels
nameofsavedfile = strcat('Pos11exp1_',growthfunction);
[param_new,min_quantity,exitflag] = ...
    batchparamestim2_fixalpha(Fk,kb,alpha,nameofsavedfile);
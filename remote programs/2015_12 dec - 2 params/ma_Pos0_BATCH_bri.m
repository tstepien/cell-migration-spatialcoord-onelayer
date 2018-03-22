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
filestring = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [767,848]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

Fk = [0.1 , 0.5 , 0.8];
kb = [1000 , 3750 , 5625];
alpha = 0.73157;
% scaling    = 10^6;
rho0 = 2025;%*scaling;

nameofsavedfile = strcat('Pos0_',growthfunction,'_apfixed');

[param_new,min_quantity,exitflag] = ...
    batchparamestim2_fixalpha(Fk,kb,alpha,nameofsavedfile);

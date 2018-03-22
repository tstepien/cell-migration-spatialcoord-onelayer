setenv MATLAB_DISABLE_CBWR 1
setenv MKL_CBWR AVX

clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_scale;
global all_exp_px allfilestrings;
global growthfunction;

% location of experimental data
allfilestrings = {'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/'; ...
    'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos11_exp1/'};

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
all_exp_px = {[767,848]; ... %size of experimental window in pixels
    [209,225]}; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

Fk = 0.75;%[0.75 , 1.5];
kb = [3750 , 7500];
alpha = [0.1 , 0.3];
% scaling    = 10^6;
rho0 = [2000 , 5000];%*scaling;

nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction);

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_multipleexplants(Fk,kb,alpha,rho0,nameofsavedfile);
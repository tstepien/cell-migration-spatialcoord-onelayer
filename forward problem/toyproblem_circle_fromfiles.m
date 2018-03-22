clc
clear variables
close all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring nameofsavedfile;
global growthfunction;

% location of data
filestring = 'emcee/toyproblem/';

figureson = 1; %%% figures on? 1=yes, 0=no
% paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('toyproblem_',growthfunction);

param.Fk   = 0.216666666666667;%0.2;
param.kb   = 1062.5;%1000;
param.alpha = 0.2;
param.rho0 = 2500;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60;%5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [440,440]; %size of experimental window in pixels
exp_scale = 1; %pixels per micron scale

%%%---------------------------------------------------------------------%%%
[density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer(param);

min_quantity = data_errorfunction(density,curve)


beep
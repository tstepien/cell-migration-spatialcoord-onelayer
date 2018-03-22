clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos1_exp2/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [522,491]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

num_intervals = 25;

nameofsavedfile = strcat('Pos1exp2_',growthfunction);

[Fk,kb,alpha,rho0,Fk_kb,Fk_alpha,Fk_rho0,kb_alpha,kb_rho0,alpha_rho0] ...
    = batchparam_surfacelkhd(num_intervals,nameofsavedfile);
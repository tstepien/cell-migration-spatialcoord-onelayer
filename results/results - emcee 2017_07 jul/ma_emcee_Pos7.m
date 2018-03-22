clc
clear variables
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions
addpath emcee
addpath rmvnrnd

global time figureson number_nodes exp_px exp_scale filestring nameofsavedfile;
global growthfunction;

% location of experimental data
filestring = 'experimental_data/SizeGapData/2014_02_21/Pos7/';

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [1021,1025]; %size of experimental window in pixels
exp_scale = .366; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('Pos7_',growthfunction);

%%% initial values for walkers (use previously calculated optimized
%%% parameter values)
%%% [F/k ; k/b ; alpha ; rho0]
mu = [0.23127 ; 2585 ; 2.24953 ; 3629];

[models,logP] = myemceerun(mu);
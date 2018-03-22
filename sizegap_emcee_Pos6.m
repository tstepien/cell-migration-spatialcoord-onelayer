clc
clear variables global
addpath emcee_mymod

global nameofsavedfile;

% location of experimental data
filestring = 'experimental_data/SizeGapData/2014_02_21/Pos6/';

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [989,924]; %size of experimental window in pixels
exp_scale = .366; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('Pos6_',growthfunction);

numruns = 4000;

%%% initial values for walkers (use previously calculated optimized
%%% parameter values) (or) (use halfway points)
%%% [F/k ; k/b ; alpha ; rho0]
% mu = [0.8 ; 1250 ; 0.5 ; 2000];
% 
% [models,logP] = myemceerun_par(mu,numruns,filestring,growthfunction,...
%     time,number_nodes,exp_px,exp_scale);

filename_previousrun = 'emcee_Pos6_logistic_masslimited_8.mat';
[models,logP] = myemceerun_par(filename_previousrun,numruns,filestring,growthfunction,...
    time,number_nodes,exp_px,exp_scale);

clc
clear variables global
addpath emcee_mymod

global nameofsavedfile;

% location of experimental data
filestring = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos6_exp3/';

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [342,352]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('Pos6exp3_',growthfunction);

numruns = 4000;

%%% initial values for walkers (use previously calculated optimized
%%% parameter values) (or) (use halfway points)
%%% [F/k ; k/b ; alpha ; rho0]
% mu = [0.8 ; 1250 ; 0.5 ; 2000];
% 
% [models,logP] = myemceerun_par(mu,numruns,filestring,growthfunction,...
%     time,number_nodes,exp_px,exp_scale);

filename_previousrun = 'emcee_Pos6exp3_logistic_masslimited_9.mat';
[models,logP] = myemceerun_par(filename_previousrun,numruns,filestring,growthfunction,...
    time,number_nodes,exp_px,exp_scale);

clc
clear variables global
addpath emcee_mymod

global nameofsavedfile;

% location of experimental data
filestring = 'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos10_exp1/';

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [238,233]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('Pos10exp1_',growthfunction);

numruns = 15;

filename_previousrun = 'emceeinit_2000samples_Pos10exp1.mat';
[models,logP] = myemceerun_par(filename_previousrun,numruns,filestring,growthfunction,...
    time,number_nodes,exp_px,exp_scale);

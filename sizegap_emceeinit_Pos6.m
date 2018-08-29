clc
clear variables global
addpath emcee_mymod

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

rng('shuffle')
numwalkers = 10000 - (1873);
threshold = 1500;

[paramval,minquant] = myemceeinit(numwalkers,threshold,filestring,...
    nameofsavedfile,growthfunction,time,number_nodes,exp_px,exp_scale);

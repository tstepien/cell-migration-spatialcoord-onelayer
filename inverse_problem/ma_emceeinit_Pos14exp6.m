clc
clear variables global
addpath ../
addpath ../emcee_mymod
addpath ../mylib_par
addpath ../mylib_par/growthfunctions
addpath ../mylib_par/shapes

% location of experimental data
filestring = '../experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos14_exp6/';

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [258,273]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

nameofsavedfile = strcat('Pos14exp6_',growthfunction);

rng('shuffle')
numwalkers = 734;%10000 - (1362+1256+650+1333+1441+1264+1226);
threshold = 1500;

[paramval,minquant] = myemceeinit(numwalkers,threshold,filestring,...
    nameofsavedfile,growthfunction,time,number_nodes,exp_px,exp_scale);

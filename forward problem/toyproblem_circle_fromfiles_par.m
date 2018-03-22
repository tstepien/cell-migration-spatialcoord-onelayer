clc
clear variables
close all

% location of data
filestring = 'emcee/toyproblem/';

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
[density,curve,time_simulation_end_early,centerdensincrease,g] ...
    = onelayer_par([param.Fk,param.kb,param.alpha,param.rho0],filestring,growthfunction,time,number_nodes,...
    exp_px,exp_scale);

[err_dist,err_densratios] = data_errorfunction_split(density,curve,exp_scale,filestring,g)


beep
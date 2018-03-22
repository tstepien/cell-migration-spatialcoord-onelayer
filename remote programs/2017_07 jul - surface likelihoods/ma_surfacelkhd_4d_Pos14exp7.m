clc
clear variables

nameofsavedfile = 'Pos14_exp7';

% location of experimental data
filestring = strcat('experimental_data/100714 Animal cap x0.8 Scion x2_0/',...
    nameofsavedfile,'/');

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [268,247]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

batchparam_surfacelkhd_4d(nameofsavedfile,filestring,...
        growthfunction,time,number_nodes,exp_px,exp_scale);

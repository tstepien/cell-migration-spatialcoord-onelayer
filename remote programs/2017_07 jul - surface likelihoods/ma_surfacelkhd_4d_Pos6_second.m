clc
clear variables

nameofsavedfile = 'Pos6';

% location of experimental data
filestring = strcat('experimental_data/SizeGapData/2014_02_21/',...
    nameofsavedfile,'/');

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [989,924]; %size of experimental window in pixels
exp_scale = .366; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

batchparam_surfacelkhd_4d_6(nameofsavedfile,filestring,...
        growthfunction,time,number_nodes,exp_px,exp_scale);

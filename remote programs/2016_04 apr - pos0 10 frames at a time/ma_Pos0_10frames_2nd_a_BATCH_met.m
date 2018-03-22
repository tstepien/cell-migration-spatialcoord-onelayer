setenv MATLAB_DISABLE_CBWR 1
setenv MKL_CBWR AVX

clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
frames = '31-40';
filestring = strcat('../RESEARCH!!!/researchdata/',...
    'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/',...
    'frames',frames,'/');

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = ((10-1)*5)/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [767,848]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
%%% 
growthfunction = 'zerogrowth_fulltime';
Fk   = [0.25 , 0.75];
kb   = [2750 , 4750];
alpha = 0;
rho0 = [1500 , 2500];

nameofsavedfile = strcat('Pos0_',growthfunction,'_frames',frames);

[param_new,min_quantity,exitflag] = batchparamestim3(Fk,kb,alpha,rho0,nameofsavedfile);


%%%---------------------------------------------------------------------%%%
frames = '41-50';
filestring = strcat('../RESEARCH!!!/researchdata/',...
    'experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/',...
    'frames',frames,'/');
nameofsavedfile = strcat('Pos0_',growthfunction,'_frames',frames);
[param_new,min_quantity,exitflag] = batchparamestim3(Fk,kb,alpha,rho0,nameofsavedfile);

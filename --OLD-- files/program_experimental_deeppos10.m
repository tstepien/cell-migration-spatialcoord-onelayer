clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../RESEARCH!!!/researchdata/experimental_data/DeepLayerPos10_full/';

global g time Phi_init figureson layerequil exp_density exp_boundary;
global expdens_init;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 0.5; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 0.66667;
param.kb   = 1066.7;
param.rho0 = 0.11333;

%%%-------------------------- time parameters --------------------------%%%
time.end = 690/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 100;
exp_px = [400,400]; %size of experimental window in pixels
exp_scale = .282; %pixels per micron scale

xmicrons = exp_px(1)/exp_scale;
ymicrons = exp_px(2)/exp_scale;
g = mesh_generation(number_nodes,xmicrons,ymicrons);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = experimentalshape(strcat(filestring,...
                          'initial_coord.txt'),strcat(filestring,...
                          'initial_mask.tif'),exp_px);

if layerequil == 0.5
    expdens_init = prep_expdata_densIC(strcat(filestring,...
        'densities.mat'));
end

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    [density,curve,velocity,Phi,plot_times] = onelayer(param);
elseif paramestim == 1
    [exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
        'densities.mat'),strcat(filestring,'boundaries.mat'),...
        exp_px);
    
    options = optimset('MaxIter',5,'Display','iter');
    param_new = fminsearch(@paramestimation,[param.Fk,param.kb,...
                                                      param.rho0],options);
end

beep
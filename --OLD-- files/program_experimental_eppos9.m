clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../RESEARCH!!!/researchdata/experimental_data/EpLayerPos9/';

global g time Phi_init figureson layerequil expdens_init;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 0.5; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 0.20413;
param.kb   = 1464.3;
scaling = 10^6;
param.rho0 = 0.0020361*scaling;

%%%-------------------------- time parameters --------------------------%%%
time.end = 395/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 100;
exp_px = [275,275]; %size of experimental window in pixels
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
[density,curve,velocity,Phi,plot_times] = onelayer(param);

beep
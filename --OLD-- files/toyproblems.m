clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../RESEARCH!!!/researchdata/experimental_data/';

global g time Phi_init figureson layerequil exp_density exp_boundary;
global expdens_init;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 0.5; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 3.6689;
param.kb   = 2302.4;
param.rho0 = 0.14473; %note: should be in mm --- (/1000/1000) ?

%%%-------------------------- time parameters --------------------------%%%
time.end = 580/60; %%% how long simulation runs in hours
time.exp_step = 10/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 250;
exp_px = [1024,1024]; %size of experimental window in pixels
exp_scale = .273; %pixels per micron scale

xmicrons = exp_px(1)/exp_scale;
ymicrons = exp_px(2)/exp_scale;
g = mesh_generation(number_nodes,xmicrons,ymicrons);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = experimentalshape('experimental_data/pos1_coord.txt',...
                             'experimental_data/pos1_mask.tif',exp_px);

% Phi_init = circleshape(1000);

if layerequil == 0.5
    expdens_init = prep_expdata_densIC(strcat(filestring,...
        'dataPos1densities'));
end

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    [density,curve,velocity,Phi,plot_times] = onelayer(param);
elseif paramestim == 1
    [exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
        'dataPos1densities'),strcat(filestring,'dataPos1boundaries'),...
        exp_px);
    
    options = optimset('MaxIter',500,'Display','iter');
    param_new = fminsearch(@paramestimation,[param.Fk,param.kb,...
                                                      param.rho0],options);
end

beep
clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../RESEARCH!!!/researchdata/experimental_data/SizeGapData/2014_03_07/Pos3/';

global g time Phi_init figureson layerequil exp_density exp_boundary;
global expdens_init rho0;

figureson = 0; %%% figures on? 1=yes, 0=no
layerequil = 0.5; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 0.8;
param.kb   = 4500;
% scaling    = 10^6;
rho0 = 1000;%0.001*scaling;

%%%-------------------------- time parameters --------------------------%%%
time.end = ((120-1)*5)/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 150;
exp_px = [677,584]; %size of experimental window in pixels
exp_scale = .573; %pixels per micron scale

xmicrons = exp_px(1)/exp_scale;
ymicrons = exp_px(2)/exp_scale;
g = mesh_generation(number_nodes,xmicrons,ymicrons);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = experimentalshape(strcat(filestring,...
                          '1.txt'),strcat(filestring,...
                          'initial_mask.tif'),exp_px);

if layerequil == 0.5
    expdens_init = prep_expdata_densIC(strcat(filestring,...
        'densities.mat'));
end

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,velocity,Phi,plot_times] = onelayer(param);
elseif paramestim == 1
    [exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
        'densities.mat'),strcat(filestring,'boundaries.mat'),...
        exp_px);
    
    options = optimset('MaxIter',1000,'Display','iter');
    [param_new,min_quantity,exitflag] = fminsearch(@paramestimation_2param,...
        [param.Fk,param.kb],options);

    expstring = strsplit(mfilename,'_');
    savefile = strcat('paramestim/',expstring{2},'/',expstring{3},...
        sprintf('_Fk_%g_kb_%g.mat',param.Fk,param.kb));
    save(savefile,'param_new','min_quantity','exitflag')
end

beep

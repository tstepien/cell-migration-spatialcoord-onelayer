clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos5_exp2/';

global g time Phi_init figureson layerequil exp_density exp_boundary;
global expdens_init rho0;

figureson = 0; %%% figures on? 1=yes, 0=no
layerequil = 0.5; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fkintcpt = 0.8;
param.Fkslope  = 0.01;
param.kbintcpt = 6000;
param.kbslope = 100;
% scaling    = 10^6;
rho0 = 1000;%0.001*scaling;

%%%-------------------------- time parameters --------------------------%%%
time.end = ((120-1)*5)/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 150;
exp_px = [394,389]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

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
    [density,curve,velocity,Phi,plot_times] = onelayer_Fk_kb_varies(param);
elseif paramestim == 1
    [exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
        'densities.mat'),strcat(filestring,'boundaries.mat'),...
        exp_px);
    
    options = optimset('MaxIter',1000,'Display','iter');
    [param_new,min_quantity,exitflag] = fminsearch(@paramestimation_Fk_kb_varies,[param.Fkintcpt,...
        param.Fkslope,param.kbintcpt,param.kbslope],options);
    
    savefile = strcat('paramestim/shirleyma/Pos5_exp2_Fk_kb_varies_b',...
        sprintf('_Fkintcpt_%g_Fkslope_%g_kbintcpt_%g_kbslope_%g.mat',...
        param.Fkintcpt,param.Fkslope,param.kbintcpt,param.kbslope));
    save(savefile,'param_new','min_quantity','exitflag','param')
end

beep
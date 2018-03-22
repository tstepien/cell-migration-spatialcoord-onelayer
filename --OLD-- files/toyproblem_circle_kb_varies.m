clc
clear all
addpath mylib
addpath shapes

global g time Phi_init figureson layerequil;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 0; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk       = .971;
param.kbintcpt = 5000;
param.kbslope  = 100;
scaling        = 10^6;
param.rho0     = .004046*scaling;

%%%-------------------------- time parameters --------------------------%%%
time.end = ((120-1)*5)/60; %%% how long simulation runs in hours
time.exp_step = 25/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 150;
exp_px = [714,689]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

xmicrons = exp_px(1)/exp_scale;
ymicrons = exp_px(2)/exp_scale;
g = mesh_generation(number_nodes,xmicrons,ymicrons);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = circleshape(1000);

%%%---------------------------------------------------------------------%%%
[density,curve,velocity,Phi,plot_times] = onelayer_kb_varies(param);

% mass = (density)*(area)
mass = zeros(length(density),1);
for i = 1:length(density)
    mass(i) = sum(sum(density{i}));
end

beep

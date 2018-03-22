clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions
% addpath ../
% addpath ../mylib
% addpath ../shapes

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = 'testingdata/';
% filestring = '../../../../../../STRAIN MAPPING/testing code/';


figureson = 0; %%% figures on? 1=yes, 0=no
paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 0.95; %1;
param.kb   = 975; %1000;
% scaling    = 10^6;
param.alpha = 0.02;%0.0985403807492872;
rho0 = 1000;%0.001*scaling;

growthfunction = 'logistic_fulltime';

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [287/.177,241/.177];%[287,241]; %size of experimental window in pixels
exp_scale = 1;%.177; %pixels per micron scale

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,curvature,plot_times] = onelayer(param);
elseif paramestim == 1
    options = optimset('MaxIter',1000,'Display','iter');
    [param_new,min_quantity,exitflag] = fminsearch(@paramestimation,...
        [param.Fk,param.kb,param.alpha],options);
    
    savefile = strcat('paramestim/testingdata',...
        sprintf('_Fk_%g_kb_%g_alpha_%g.mat',param.Fk,param.kb,param.alpha));
    save(savefile,'param_new','min_quantity','exitflag','param')
end
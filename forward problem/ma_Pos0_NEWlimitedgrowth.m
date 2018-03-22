clc
clear all
close all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;
global g; %this is for saving the data files

% location of experimental data
filestring = '../../../../../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/';

figureson = 1; %%% figures on? 1=yes, 0=no
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
% %%%
% growthfunction = 'constant_masslimited';
% param.Fk   = 2.53547;
% param.kb   = 81475;
% param.alpha = 252.53452;
% rho0 = 28947;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

% %%%
% growthfunction = 'exponential_masslimited';
% param.Fk   = 2.52137;
% param.kb   = 81697;
% param.alpha = 0.10168;
% rho0 = 28900;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

% %%%
% growthfunction = 'inverse_masslimited';
% param.Fk   = 2.61739;
% param.kb   = 81411;
% param.alpha = 491489.83240;
% rho0 = 29045;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

%%%
growthfunction = 'logistic_masslimited';
% param.Fk   = 2.28505;
% param.kb   = 79540;
% param.alpha = 0.10989;
% rho0 = 23542;
% % % scaling    = 10^6;
% % % rho0 = 0.001*scaling; %cells/mm^2



param.Fk   = 1.5;
param.kb   = 7500;
param.alpha = 0.3;
rho0 = 5000;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [767,848]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,curvature,plot_times,...
        newmassadded] = onelayer(param);
    
    exp_densratio = [];
    exp_boundary = [];
elseif paramestim == 1
    options = optimset('MaxIter',1000,'Display','iter');
    [param_new,min_quantity,exitflag] = fminsearch(@paramestimation,...
        [param.Fk,param.kb,param.alpha],options);
    
    savefile = strcat('paramestim/shirleyma_Pos0',...
        sprintf('_Fk_%g_kb_%g_alpha_%g.mat',param.Fk,param.kb,param.alpha));
    save(savefile,'param_new','min_quantity','exitflag','param')
end


min_quantity = data_errorfunction(density,curve)

% savefile = strcat('/Users/tracystepien/Desktop/RESEARCH!!!/',...
%     'STUFFFFF STRAIN MACRO/PARAMETER ESTIMATION FILES/',...
%     '2015_10 mass limited growth functions/simulations/',...
%     'Pos0_',growthfunction,'.mat');
% save(savefile)

figure
plot(time.timewholesim(2:end),newmassadded)
xlabel('time')
ylabel('mass added')

figure
plot(time.timewholesim(2:end),cumsum(newmassadded))
xlabel('time')
ylabel('cumulative sum of mass added')




beep
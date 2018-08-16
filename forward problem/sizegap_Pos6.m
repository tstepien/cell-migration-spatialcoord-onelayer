clc
clear variables
close all
addpath ../
addpath ../mylib
addpath ../mylib/shapes
addpath ../mylib/growthfunctions

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = '../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/SizeGapData/2014_02_21/Pos6/';

figureson = 1; %%% figures on? 1=yes, 0=no
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
%%%
growthfunction = 'logistic_masslimited';
%%% min value
param.Fk   = 0.8376;
param.kb   = 646;
param.alpha = 0.9474;
rho0 = 1725;

%%% average value
% param.Fk   = 0.4907;
% param.kb   = 2365;
% param.alpha = 0.4439;
% rho0 = 1496;

% param.Fk   = 0.43159;
% param.kb   = 910;
% param.alpha = 2.50122;
% rho0 = 2931;
% scaling    = 10^6;
% rho0 = 0.001*scaling; %cells/mm^2

% % %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.84343;
% param.kb   = 719;
% param.alpha = 0.73157;
% rho0 = 2025;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [989,924]; %size of experimental window in pixels
exp_scale = .366; %pixels per micron scale

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer(param);
    
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

% savefile = strcat('/Users/tracystepien/Desktop/RESEARCH!!!/STUFFFFF STRAIN MACRO/PARAMETER ESTIMATION FILES/simulations/',...
%     'Pos0_',growthfunction,'.mat');
% save(savefile)



min_quantity = data_errorfunction(density,curve)


global init_mass;

figure
plot(time.timewholesim(2:end),init_mass*ones(size(time.timewholesim(2:end))),...
    time.timewholesim(2:end),cumsum(newmassadded))
xlabel('time (hr)','FontSize',14)
ylabel('cumulative sum of mass added (cells)','FontSize',14)
set(gca,'FontSize',12)


beep



% %%% mass limited growth function with rho(0)=4700 and no restrictions on
% ending density (from 12/2015 parameter estimation)
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.39831;
% param.kb   = 861;
% param.alpha = 3.35821;
% rho0 = 2802;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% mass limited growth function with rho(0)=4700 and no restrictions on
% ending density (from 12/2015 parameter estimation)
% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.64967;
% param.kb   = 1672;
% param.alpha = 0.45623;
% rho0 = 2978;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2










% %%% masslimited growth function but with rho(0)=2700
% (from 11/2015 parameter estimation)
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.19368;
% param.kb   = 5607;
% param.alpha = 1.42770;
% rho0 = 2231;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% masslimited growth function but with rho(0)=2700
% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.46924;
% param.kb   = 3041;
% param.alpha = 0.40243;
% rho0 = 2009;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2







% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 1.43561;
% param.kb   = 6720;
% param.alpha = 0.18462;
% rho0 = 8728;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.59481;
% param.kb   = 5921;
% param.alpha = 0.32277;
% rho0 = 3734;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2
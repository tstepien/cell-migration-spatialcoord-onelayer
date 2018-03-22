clc
clear all
close all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = '../../../../../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos2_exp1/';

figureson = 1; %%% figures on? 1=yes, 0=no
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
%%%
growthfunction = 'logistic_masslimited';
param.Fk   = 0.16441;
param.kb   = 11610;
param.alpha = 1.49698;
rho0 = 3952;
% scaling    = 10^6;
% rho0 = 0.001*scaling; %cells/mm^2

% % %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.84126;
% param.kb   = 1078;
% param.alpha = 0.73157;
% rho0 = 2025;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2


%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [492,504]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

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
% param.Fk   = 0.22045;%1.22771;
% param.kb   = 25438;%55583;
% param.alpha = 0.46910;%0.09704;
% rho0 = 4731;%13859;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% mass limited growth function with rho(0)=4700 and no restrictions on
% ending density (from 12/2015 parameter estimation)
% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.66884;
% param.kb   = 2498;
% param.alpha = 0.45623;
% rho0 = 2978;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2












% %%% masslimited growth function but with rho(0)=2700
% (from 11/2015 parameter estimation)
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.81334;%2.68143;
% param.kb   = 21129;%49837;
% param.alpha = 0.12151;%0.08979;
% rho0 = 4350;%33856;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% masslimited growth function but with rho(0)=2700
% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.50557;
% param.kb   = 4649;
% param.alpha = 0.40243;
% rho0 = 2009;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2






% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 1.0618;
% param.kb   = 30756;
% param.alpha = 0.13595;
% rho0 = 6893;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.44981;
% param.kb   = 17438;
% param.alpha = 0.32277;
% rho0 = 3734;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2
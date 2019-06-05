clc
clear variables
close all
addpath ..
addpath ../mylib
addpath ../mylib/shapes
addpath ../mylib/growthfunctions

global time figureson rho0 number_nodes exp_px exp_scale filestring;
global growthfunction;

% location of experimental data
filestring = '../experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/';

figureson = 1; %%% figures on? 1=yes, 0=no
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
%%% 
growthfunction = 'logistic_masslimited';
%%% from min
param.Fk   = 0.9845;
param.kb   = 1321;
param.alpha = 0.9903;
rho0 = 1372;

% %%% fit #1
% param.Fk   = 103/120; %0.8583
% param.kb   = 1625;
% param.alpha = 1;
% rho0 = 2000;

% %%% fit #2
% param.Fk   = 41/60; %0.6833
% param.kb   = 2562.5;
% param.alpha = 1;
% rho0 = 2000;

% %%% fit #3
% param.Fk   = 19/15; %1.26
% param.kb   = 875;
% param.alpha = 0.4;
% rho0 = 2000;

% %%% fit #4
% param.Fk   = 0.1;
% param.kb   = 2000;
% param.alpha = 0.4;
% rho0 = 2500;

% param.Fk   = 1.26309;
% param.kb   = 416;
% param.alpha = 2.43569;
% rho0 = 1239;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% Pos0 and Pos11exp1 together
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.84382;
% param.kb   = 1902;
% param.alpha = 0.73157;
% rho0 = 2025;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.67339;
% param.kb   = 2926;
% param.alpha = 0.73157;
% rho0 = 2025;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

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
    time.timewholesim(2:end),init_mass/2*ones(size(time.timewholesim(2:end))),...
    time.timewholesim(2:end),cumsum(newmassadded))
xlabel('time (hr)','FontSize',14)
ylabel('cumulative sum of mass added (cells)','FontSize',14)
set(gca,'FontSize',12)





beep




% %%% mass limited growth function with rho(0)=4700 and no restrictions on
% ending density (from 12/2015 parameter estimation)
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.23406;
% param.kb   = 8230;
% param.alpha = 2.06949;
% rho0 = 3250;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% mass limited growth function with rho(0)=4700 and no restrictions on
% ending density (from 12/2015 parameter estimation)
% %%% Pos0 and Pos11exp1 together
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.59215;
% param.kb   = 5431;
% param.alpha = 0.45623;
% rho0 = 2978;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

% %%% mass limited growth function with rho(0)=4700 and no restrictions on
% ending density (from 12/2015 parameter estimation)
% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.61068;
% param.kb   = 5228;
% param.alpha = 0.45623;
% rho0 = 2978;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

















% %%% masslimited growth function but with rho(0)=2700
% (from 11/2015 parameter estimation)
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.18703;
% param.kb   = 10904;
% param.alpha = 2.34509;
% rho0 = 1925;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

% %%% masslimited growth function but with rho(0)=2700
% %%% Pos0 and Pos11exp1 together
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.38245;
% param.kb   = 13288;
% param.alpha = 0.40243;
% rho0 = 2009;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

% %%% masslimited growth function but with rho(0)=2700
% %%% alpha/rho0 fixed
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.46951;
% param.kb   = 9542;
% param.alpha = 0.40243;
% rho0 = 2009;
% % scaling    = 10^6;
% % rho0 = 0.001*scaling; %cells/mm^2

% %%% masslimited growth function but with rho(0)=2700
% growthfunction = 'zerogrowth_fulltime';
% param.Fk   = 1.17128;
% param.kb   = 5864;
% param.alpha = 0.11575;
% rho0 = 1642;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2






% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 2.44201;
% param.kb   = 80964;
% param.alpha = 0.10926;
% rho0 = 27502;
% % % % scaling    = 10^6;
% % % % rho0 = 0.001*scaling; %cells/mm^2

% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.58300;
% param.kb   = 17422;
% param.alpha = 0.32277;
% rho0 = 3734;

% %%%
% growthfunction = 'exponential_fulltime';
% param.Fk   = 0.461625317154280;
% param.kb   = 1202.92960169166;
% param.alpha = 0.717836437540443;
% scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'exponential_after6hr';
% param.Fk   = 0.705656481215321;
% param.kb   = 5485.83698639139;
% param.alpha = 0.772055575793492;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.280402964944208;
% param.kb   = 5802.16632775398;
% param.alpha = 2.31420102423131;
% scaling    = 10^6;
% rho0 = 0.001*scaling; %cells/mm^2

% %%%
% growthfunction = 'logistic_after6hr';
% param.Fk   = 0.692588970906462;
% param.kb   = 5423.23085733724;
% param.alpha = 1.67934809380574;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_fulltime';
% param.Fk   = 0.174282484584924;
% param.kb   = 8293.82583563466;
% param.alpha = 345.324301495369;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_after6hr';
% param.Fk   = 0.360231691458235;
% param.kb   = 23972.7916526955;
% param.alpha = 340.189073840346;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'zerogrowth_fulltime';
% param.Fk   = 0.839798833715515;
% param.kb   = 5788.72184948481;
% param.alpha = 0;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'exponential_then_logistic';
% param.Fk   = 2.32956709596389;
% param.kb   = 49.1839499289240;
% param.alpha = 4.22507463249880;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_then_exponential';
% param.Fk   = 0.168906167804403;
% param.kb   = 10777.6202663094;
% param.alpha = 0.250358200080085;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_then_exponential';
% param.Fk   = 0.108268896236078;
% param.kb   = 5724.94097405709;
% param.alpha = 0.408732907428806;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_then_logistic';
% param.Fk   = 0.316042962538006;
% param.kb   = 7341.50285492177;
% param.alpha = 1.52517165851104;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_then_constant';
% param.Fk   = 0.707555372749103;
% param.kb   = 5150.92699688319;
% param.alpha = 1.70354839876818;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

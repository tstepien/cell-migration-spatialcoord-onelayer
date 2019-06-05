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
filestring = '../experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos14_exp8/';

figureson = 1; %%% figures on? 1=yes, 0=no
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
%%%
growthfunction = 'logistic_masslimited';
% param.Fk   = 1.70123422699738;
% param.kb   = 106.280813259079;
% param.alpha = 0.927048377860413;
% rho0 = 693.409793923449;

% % % %%% for anisotropic vs. isotropic study
param.Fk   = 0.6833;
param.kb   = 500;
param.alpha = 1;
rho0 = 1500;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [287,241]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%---------------------------------------------------------------------%%%
% if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer(param);
%     [density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer_varyingkb(param);
    
    exp_densratio = [];
    exp_boundary = [];
% elseif paramestim == 1
%     options = optimset('MaxIter',1000,'Display','iter');
%     [param_new,min_quantity,exitflag] = fminsearch(@paramestimation,...
%         [param.Fk,param.kb,param.alpha],options);
%     
%     savefile = strcat('paramestim/shirleyma_Pos14exp8',...
%         sprintf('_Fk_%g_kb_%g_alpha_%g.mat',param.Fk,param.kb,param.alpha));
%     save(savefile,'param_new','min_quantity','exitflag','param')
% end

% savefile = strcat('/Users/tracystepien/Desktop/RESEARCH!!!/STUFFFFF STRAIN MACRO/PARAMETER ESTIMATION FILES/simulations/',...
%     'Pos14exp8_',growthfunction,'.mat');
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
% %%%
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.34701;
% param.kb   = 2352;
% param.alpha = 0.45623;
% rho0 = 2978;
% % % % % scaling    = 10^6;
% % % % rho0 = 1000;%0.001*scaling; %cells/mm^2










% %%% masslimited growth function but with rho(0)=2700
% growthfunction = 'logistic_masslimited';
% param.Fk   = 0.31872;
% param.kb   = 4116;
% param.alpha = 0.40243;
% rho0 = 2009;
% % % % % scaling    = 10^6;
% % % % rho0 = 1000;%0.001*scaling; %cells/mm^2








% %%%
% growthfunction = 'exponential_fulltime';
% param.Fk   = 0.399578933867553;
% param.kb   = 1248.14216889033;
% param.alpha = 0.220052626773505;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'exponential_after6hr';
% param.Fk   = 0.772744933968987;
% param.kb   = 1085.12138397503;
% param.alpha = 0.550816494517848;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.240897300626362;
% param.kb   = 3248.49876013006;
% param.alpha = 0.920550939013119;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_after6hr';
% param.Fk   = 0.764952929995335;
% param.kb   = 1093.23034380753;
% param.alpha = 0.946513031400307;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_fulltime';
% param.Fk   = 0.852940781329257;
% param.kb   = 1073.45681876956;
% param.alpha = 7.20342085711938;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_after6hr';
% param.Fk   = 0.904910143012491;
% param.kb   = 973.926009662142;
% param.alpha = 11.7551483558282;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'zerogrowth_fulltime';
% param.Fk   = 0.960794468328658;
% param.kb   = 861.411622175838;
% param.alpha = 0;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'exponential_then_logistic';
% param.Fk   = 0.537892892862102;
% param.kb   = 1019.62157273546;
% param.alpha = 0.474787956372443;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_then_exponential';
% param.Fk   = 0.247266473271276;
% param.kb   = 2708.20053329448;
% param.alpha = 0.199775847209216;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_then_exponential';
% param.Fk   = 0.326994746110039;
% param.kb   = 1279.69343437831;
% param.alpha = 0.276880410400744;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'constant_then_logistic';
% param.Fk   = 0.268806531369888;
% param.kb   = 1951.75720707347;
% param.alpha = 1.43155457774631;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'exponential_then_constant';
% param.Fk   = 0.743836347242209;
% param.kb   = 1179.09172833755;
% param.alpha = 0.525968038620370;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;

% %%%
% growthfunction = 'logistic_then_constant';
% param.Fk   = 0.761636097551546;
% param.kb   = 1096.16928092677;
% param.alpha = 0.947855713024305;
% % scaling    = 10^6;
% rho0 = 1000;%0.001*scaling;





% %%%
% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.84033;
% param.kb   = 3150;
% param.alpha = 0.22691;
% rho0 = 3799;
% % % % % scaling    = 10^6;
% % % % rho0 = 1000;%0.001*scaling; %cells/mm^2

% growthfunction = 'logistic_fulltime';
% param.Fk   = 0.87785;
% param.kb   = 1707;
% param.alpha = 0.32277;
% rho0 = 3734;
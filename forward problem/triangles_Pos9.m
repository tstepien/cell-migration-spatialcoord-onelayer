clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../../RESEARCH!!!/researchdata/experimental_data/2014-06-11_ACTriangles/Pos9/';

global g time Phi_init figureson layerequil exp_densratio exp_boundary rho0;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 0; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 1.5;
param.kb   = 1000;
% scaling    = 10^6;
rho0 = 1000;%0.001*scaling;

%%%-------------------------- time parameters --------------------------%%%
time.end = ((144-1)*5)/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 100;
exp_px = [1360,1024]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

g = mesh_generation(number_nodes,exp_px,exp_scale);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = experimentalshape(strcat(filestring,'1.txt'),...
    strcat(filestring,'initial_mask.tif'),exp_px);

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,plot_times] = onelayer(param);
% elseif paramestim == 1
%     [exp_densratio,exp_boundary] = prep_expdata(strcat(filestring,...
%         'densities.mat'),strcat(filestring,'boundaries.mat'),...
%         exp_px);
%     
%     options = optimset('MaxIter',1000,'Display','iter');
%     param_new = fminsearch(@paramestimation_2param,[param.Fk,param.kb],...
%         options);
end

beep




% figure
% [exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
%         'densities.mat'),strcat(filestring,'boundaries.mat'),...
%         exp_px);
% 
% for i = 1:length(exp_density)
%     exp_sumdens(i) = rho0*sum(sum(exp_density{i}));
% end
% for i = 1:length(density)
%     sumdens(i) = sum(sum(density{i}));
% end
% 
% plot(1:length(exp_density),exp_sumdens,1:length(density),sumdens)
% 
% xlabel('frame #')
% ylabel('mass (sum of densities)')
% legend('experiment','numerical')
% 
% 
% 
% for k = 1:length(density)-1
%     densratio{k} = zeros(number_nodes,number_nodes);
%     for i = 1:number_nodes
%         for j = 1:number_nodes
%             if density{k+1}(i,j)~=0
%                 densratio{k}(i,j) = density{k}(i,j)/density{k+1}(i,j);
%             end
%         end
%     end
%     sumdensratio(k) = sum(sum(densratio{k}));
% end
% 
% 
% for k = 1:length(exp_density)
%     exp_densratio{k} = zeros(number_nodes,number_nodes);
%     for i = 1:number_nodes
%         for j = 1:number_nodes
%             if exp_density{k}(i,j)~=0
%                 exp_densratio{k}(i,j) = 1/density{k}(i,j);
%             end
%         end
%     end
%     exp_sumdensratio(k) = sum(sum(exp_densratio{k}));
% end
% 
% 
% plot(1:length(exp_density),sumexp_densratio,1:length(density)-1,sumdensratio)
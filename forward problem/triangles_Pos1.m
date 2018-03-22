clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../../RESEARCH!!!/researchdata/experimental_data/2014-06-11_ACTriangles/Pos1/';

global g time Phi_init figureson layerequil exp_densratio exp_boundary rho0;
global alpha;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 1; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 1.5;
param.kb   = 1000;
% scaling    = 10^6;
rho0 = 1000;%0.001*scaling;
alpha = 0.06640584;

%%%-------------------------- time parameters --------------------------%%%
time.end = ((144-1)*5)/60; %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 100;
exp_px = [617,603]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

g = mesh_generation(number_nodes,exp_px,exp_scale);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = experimentalshape(strcat(filestring,'1.txt'),...
    strcat(filestring,'initial_mask.tif'),exp_px);

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,curvature,plot_times] = onelayer(param);
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


figure
Pos1_area = dlmread('../../imagej/area extraction/2014-06-11_ACTriangles/Pos1_areas.txt');
plot(1:length(Pos1_area),Pos1_area/exp_scale^2',1:length(area),area(1:end))
legend('experimental','numerical','Location','SouthEast')

% % % figure
% % % [exp_densratio,exp_boundary] = prep_expdata(strcat(filestring,...
% % %     'densratios.mat'),strcat(filestring,'boundaries.mat'),exp_px);
% % % 
% % % densratio_model = cell(1,length(density)-1);
% % % for i = 1:length(density)-1
% % %     densratio_model{i} = zeros(number_nodes,number_nodes);
% % %     for m = 1:number_nodes
% % %         for n = 1:number_nodes
% % %             if density{i+1}(m,n)~=0
% % %                 densratio_model{i}(m,n) = density{i}(m,n)./density{i+1}(m,n);
% % %             end
% % %         end
% % %     end
% % % end
% % %    
% % % exp_sumdensratio = zeros(1,length(exp_densratio));
% % % for i = 1:length(exp_densratio)
% % %     exp_sumdensratio(i) = sum(sum(exp_densratio{i}));
% % % end
% % % sumdensratio = zeros(1,length(density)-1);
% % % for i = 1:length(density)-1
% % %     sumdensratio(i) = sum(sum(densratio_model{i}));
% % % end
% % % 
% % % plot(1:length(exp_densratio),exp_sumdensratio,1:length(density)-1,sumdensratio)
% % % 
% % % xlabel('frame #')
% % % ylabel('total change in mass (sum of density ratios)')
% % % legend('experiment','numerical','Location','SouthEast')
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
%     exp_densratio{k} = zeros(number_'nodes,number_nodes);
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
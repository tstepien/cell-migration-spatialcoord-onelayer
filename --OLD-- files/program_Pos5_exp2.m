clc
clear all
addpath mylib
addpath shapes

% location of experimental data
filestring = '../../../../../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos5_exp2/';

global g time Phi_init figureson layerequil exp_density exp_boundary;
global expdens_init rho0;

figureson = 1; %%% figures on? 1=yes, 0=no
layerequil = 0.5; %%% layer at equilibrium? 1=yes, 0=no, 0.5=experiment
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
param.Fk   = 0.8012991691;
param.kb   = 6833.3317566531;
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
                      
                      stop

if layerequil == 0.5
    expdens_init = prep_expdata_densIC(strcat(filestring,...
        'densities.mat'));
end

%%%---------------------------------------------------------------------%%%
if paramestim == 0
    param.rho0 = rho0;
    [density,curve,area,velocity,Phi,plot_times] = onelayer(param);
elseif paramestim == 1
    [exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
        'densities.mat'),strcat(filestring,'boundaries.mat'),...
        exp_px);
    
    options = optimset('MaxIter',1000,'Display','iter');
    param_new = fminsearch(@paramestimation_2param,[param.Fk,param.kb],...
        options);
end

beep




figure
[exp_density,exp_boundary] = prep_expdata(strcat(filestring,...
        'densities.mat'),strcat(filestring,'boundaries.mat'),...
        exp_px);

for i = 1:length(exp_density)
    exp_sumdens(i) = rho0*sum(sum(exp_density{i}));
end
for i = 1:length(density)
    sumdens(i) = sum(sum(density{i}));
end

plot(1:length(exp_density),exp_sumdens,1:length(density),sumdens)

xlabel('frame #')
ylabel('mass (sum of densities)')
legend('experiment','numerical')



for k = 1:length(density)-1
    densratio{k} = zeros(number_nodes,number_nodes);
    for i = 1:number_nodes
        for j = 1:number_nodes
            if density{k+1}(i,j)~=0
                densratio{k}(i,j) = density{k}(i,j)/density{k+1}(i,j);
            end
        end
    end
    sumdensratio(k) = sum(sum(densratio{k}));
end


for k = 1:length(exp_density)
    exp_densratio{k} = zeros(number_nodes,number_nodes);
    for i = 1:number_nodes
        for j = 1:number_nodes
            if exp_density{k}(i,j)~=0
                exp_densratio{k}(i,j) = 1/density{k}(i,j);
            end
        end
    end
    exp_sumdensratio(k) = sum(sum(exp_densratio{k}));
end


plot(1:length(exp_density),sumexp_densratio,1:length(density)-1,sumdensratio)




% for i = 1:120
%     [ch areaofexp(i)] = convhull(curve{i}(1,:),curve{i}(2,:));
%     mass{i} = density{i}*areaofexp(i);
%     totalmass(i) = sum(sum(mass{i}));
% end
% figure
% plot(1:120,totalmass)
% for i = 1:119
%     [ch exp_areaofexp(i)] = convhull(exp_boundary{i}(1,:),exp_boundary{i}(2,:));
%     exp_mass{i} = exp_density{i}*exp_areaofexp(i);
%     exp_totalmass(i)=sum(sum(exp_mass{i}));
% end
% figure
% plot(1:119,exp_totalmass)
% 
% figure
% plot(1:119,areaofexp(2:120),1:119,exp_areaofexp)
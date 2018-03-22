clc
clear variables
close all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global g time Phi_init figureson growthfunction;

figureson = 1; %%% figures on? 1=yes, 0=no
paramestim = 0; %%% parameter estimation? 1=yes, 0=no

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';
param.Fk   = 0.5;
param.kb   = 1300;
param.alpha = 0.75;
param.rho0 = 2000;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60;%5/60; %%% how many hours between recording a curve

%%%--------------------------- generate mesh ---------------------------%%%
number_nodes = 100;
exp_px = [500,500]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%--------------------------- generate mesh ---------------------------%%%
g = mesh_generation(number_nodes,exp_px,exp_scale);

%%%------------------- initial cell boundary shapes --------------------%%%
%%%---------------------- (initialize level sets) ----------------------%%%
Phi_init = circleshape(750);

%%%---------------------------------------------------------------------%%%
[density,curve,area,velocity,Phi,curvature,plot_times,newmassadded] = onelayer_toy(param);

% % mass = (density)*(area)
mass = zeros(length(density),1);
for i = 1:length(density)
    mass(i) = sum(sum(density{i}))*g.dx*g.dy;
end


figure
plot(time.timewholesim(2:end),newmassadded)
xlabel('time')
ylabel('mass added')


beep

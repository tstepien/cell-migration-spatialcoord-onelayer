clc
clear variables
close all
addpath ../
addpath ../mylib_par
addpath ../mylib_par/shapes
addpath ../mylib_par/growthfunctions

% location of experimental data
filestring = '../experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos6_exp4/';

%%%------------------------- model parameters --------------------------%%%
%%%
growthfunction = 'logistic_masslimited';
Fk   = 0.684107996420274;
kb   = 958.265097381738;
alpha = 1.52248203167132;
rho0 = 1623.90776569924;

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_px = [422,384]; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%---------------------------------------------------------------------%%%

[density,curve,time_simulation_end_early,centerdensincrease,g] ...
    = onelayer_par([Fk,kb,alpha,rho0],filestring,growthfunction,time,...
    number_nodes,exp_px,exp_scale);

if time_simulation_end_early==0
    [err_total,err_dist,err_densratios] = data_errorfunction_split(density,...
        curve,exp_scale,filestring,g);
end
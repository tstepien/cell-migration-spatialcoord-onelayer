clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_scale;
global all_exp_px allfilestrings;
global growthfunction;

% location of experimental data
allfilestrings = {'../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/'; ...
    '../RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos11_exp1/'};

figureson = 0; %%% figures on? 1=yes, 0=no
% paramestim = 1; %%% parameter estimation? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
all_exp_px = {[767,848]; ... %size of experimental window in pixels
    [209,225]}; %size of experimental window in pixels
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

% Fk = [0.75 , 1.5];
% kb = [3750 , 7500];
% alpha = [0.1 , 0.3];
% % scaling    = 10^6;
% rho0 = [2000 , 5000];%*scaling;

% nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction);
% 
% [param_new,min_quantity,exitflag] = ...
%     batchparamestim4_multipleexplants(Fk,kb,alpha,rho0,nameofsavedfile);



Fk = [0.449860224921062,0.356855212596904];
kb = [18662.6991384830,8289.39459864646];
alpha = 0.255173350708440;
rho0 = 2484.42481993538;

nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction,'_1');

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_multipleexplants2(Fk,kb,alpha,rho0,nameofsavedfile);






Fk = [0.582917458764571,0.302180516911911];
kb = [6977.08312069940,4347.50759989600];
alpha = 0.362402087982825;
rho0 = 1819.51724273955;

nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction,'_2');

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_multipleexplants2(Fk,kb,alpha,rho0,nameofsavedfile);





Fk = [0.695901908691399,0.644676086216602];
kb = [10677.1951397278,2771.77928759597];
alpha = 0.199183825851115;
rho0 = 2447.58338245242;

nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction,'_3');

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_multipleexplants2(Fk,kb,alpha,rho0,nameofsavedfile);







Fk = [0.820243783207869,0.469406765104090];
kb = [8971.46642834219,8163.83864982864];
alpha = 0.189556108507719;
rho0 = 2571.11258576890;

nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction,'_4');

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_multipleexplants2(Fk,kb,alpha,rho0,nameofsavedfile);






Fk = [0.758856316719279,0.840466261260792];
kb = [4838.40283306719,866.688535262762];
alpha = 0.306471776762125;
rho0 = 1641.29351913650;

nameofsavedfile = strcat('Pos0_and_Pos11exp1_',growthfunction,'_5');

[param_new,min_quantity,exitflag] = ...
    batchparamestim4_multipleexplants2(Fk,kb,alpha,rho0,nameofsavedfile);
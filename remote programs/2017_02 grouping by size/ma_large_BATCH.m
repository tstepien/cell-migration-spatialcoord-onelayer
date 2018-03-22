clc
clear all
addpath mylib
addpath mylib/shapes
addpath mylib/growthfunctions

global time figureson number_nodes exp_px exp_scale filestring;
global growthfunction;

figureson = 0; %%% figures on? 1=yes, 0=no

%%%-------------------------- time parameters --------------------------%%%
time.end = (120-1)*(5/60); %%% how long simulation runs in hours
time.exp_step = 5/60; %%% how many hours between recording a curve

%%%--------------------------- mesh details ----------------------------%%%
number_nodes = 100;
exp_scale = .177; %pixels per micron scale

%%%------------------------- model parameters --------------------------%%%
growthfunction = 'logistic_masslimited';

%%%---------------------------------------------------------------------%%%

numRuns = 10;

Fk = [1.26309; 0.17052; 0.16441];
kb = [416; 9542; 11610];
alpha = [2.43569; 1.67514; 1.49698];
rho0 = [1239; 3935; 3952];

%parpool(3)
for i=1:numRuns
    for j=1:3
        if j==1
            expl = 'Pos0';
        elseif j==2
            expl = 'Pos1_exp2';
        elseif j==3
            expl = 'Pos2_exp1';
        end
        
        % location of experimental data
        filestring = strcat('experimental_data/100714 Animal cap x0.8 Scion x2_0/',expl,'/');
        nameofsavedfile = strcat(expl,'_',num2str(i),'_',growthfunction);
        
        if strcmp(expl,'Pos0')
            exp_px = [767,848]; %size of experimental window in pixels
            
            [param_new0,min_quantity0,exitflag0] = ...
                batchparamestim4_lessconstraints(Fk(2),kb(2),alpha(2),...
                rho0(2),nameofsavedfile);
        elseif strcmp(expl,'Pos1_exp2')
            exp_px = [522,491];
            
            [param_new12,min_quantity12,exitflag12] = ...
                batchparamestim4_lessconstraints(Fk(3),kb(3),alpha(3),...
                rho0(3),nameofsavedfile);
        elseif strcmp(expl,'Pos2_exp1')
            exp_px = [492,504];
            
            [param_new21,min_quantity21,exitflag21] = ...
                batchparamestim4_lessconstraints(Fk(1),kb(1),alpha(1),...
                rho0(1),nameofsavedfile);
        end
    end
    Fk = [param_new0(1); param_new12(1); param_new21(1)];
    kb = [param_new0(2); param_new12(2); param_new21(2)];
    alpha = [param_new0(3); param_new12(3); param_new21(3)];
    rho0 = [param_new0(4); param_new12(4); param_new21(4)];
end
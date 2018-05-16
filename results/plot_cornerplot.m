clear variables;
clc;
close all;

addpath ../emcee_mymod

names = {'Pos2exp1'};
% names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6'};

LN = length(names);

p = zeros(4,2000*LN);
for i=1:LN
    load(strcat('emceeinit_2000samples_',names{i},'.mat'))
    p(:,(i-1)*2000+1:i*2000) = paramval;
end

figure
H=ecornerplot(p,'names',{'$F/k$','$k/b$','$\alpha$','$\rho_\mathrm{unstressed}$'},'ks',true);

set(gcf,'Units','inches','Position',[2,2,10,8],'PaperPositionMode','auto')
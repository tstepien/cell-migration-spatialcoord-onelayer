clear variables;
clc;
close all;

addpath ../emcee_mymod

names = 'Pos6exp3';

load(strcat('emceeinit_2000samples_',names,'.mat'))

figure
H=ecornerplot(paramval,'names',{'$F/k$','$k/b$','$\alpha$','$\rho_\mathrm{unstressed}$'},'ks',true);

set(gcf,'Units','inches','Position',[2,2,10,8],'PaperPositionMode','auto')
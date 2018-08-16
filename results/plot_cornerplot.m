clear variables;
clc;
close all;

addpath ../emcee_mymod

% names = {'Pos2exp1'};
names = {'Pos6exp3'}; %%% this is the explant used in the paper
% names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6'};

LN = length(names);
numparametersets = 10000;

p = zeros(4,numparametersets*LN);
for i=1:LN
    load(strcat('emceeinit_10000samples_',names{i},'.mat'))
    p(:,(i-1)*numparametersets+1:i*numparametersets) = paramval;
end

numkeep = 3; %number to keep for scatter plot
[sortedValues,sortIndex] = sort(minquant);
minIndex = sortIndex(1:numkeep);

minparam = models(:,minIndex);
avgval = [mean(models(1,:)) , mean(models(2,:)) , mean(models(3,:)) , ...
    mean(models(4,:))];

figure
H = ecornerplot(p,minparam,avgval,'names',{'$F/k$','$k/b$','$\alpha$','$\rho_\mathrm{unstressed}$'},'ks',true);



set(gcf,'Units','inches','Position',[2,2,10,8],'PaperPositionMode','auto')
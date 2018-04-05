clear variables;
clc;
close all;

names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6','Pos10exp1',...
    'Pos5exp4','Pos6exp3','Pos7exp4','Pos6exp4','Pos9exp2','Pos9exp3',...
    'Pos9exp1','Pos6','Pos7','Pos1exp2','Pos2exp1','Pos0'};

LN = length(names);

xbar = zeros(LN,4);
s = zeros(LN,4);

n = 2000;
tstar = tinv((1+0.95)/2 , n-1);

CIlower = zeros(LN,4);
CIupper = zeros(LN,4);

Fk = zeros(n,LN);
kb = zeros(n,LN);
alpha = zeros(n,LN);
rho0 = zeros(n,LN);


for i = 1:length(names)
    load(strcat('emcee_',names{i},'_15iterations.mat'))
    
    m = models(:,:,15)';
    Fk(:,i) = m(:,1);
    kb(:,i) = m(:,2);
    alpha(:,i) = m(:,3);
    rho0(:,i) = m(:,4);
    
    for j = 1:4
        xbar(i,j) = mean(m(:,j));
        s(i,j) = std(m(:,j));
        
        CIlower(i,j) = xbar(i,j) - tstar * s(i,j)/sqrt(n);
        CIupper(i,j) = xbar(i,j) + tstar * s(i,j)/sqrt(n);
    end
    
end

%%% for comparison, defaults are:
%%%     alpha=0.05
%%%     Tukey-Kramer (Tukey's honest significant difference criterion)

[p_Fk,tbl_Fk,stats_Fk] = anova1(Fk,names);
figure
[c_Fk,h_Fk] = multcompare(stats_Fk);
yticklabels(flip(names))

[p_kb,tbl_kb,stats_kb] = anova1(kb);
figure
[c_kb,h_kb] = multcompare(stats_kb);
yticklabels(flip(names))

[p_alpha,tbl_alpha,stats_alpha] = anova1(alpha);
figure
[c_alpha,h_alpha] = multcompare(stats_alpha);
yticklabels(flip(names))

[p_rho0,tbl_rho0,stats_rho0] = anova1(rho0);
figure
[c_rho0,h_rho0] = multcompare(stats_rho0);
yticklabels(flip(names))

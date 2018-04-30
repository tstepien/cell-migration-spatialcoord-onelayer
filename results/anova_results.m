clear variables;
clc;
close all;

names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6','Pos10exp1',...
    'Pos5exp4','Pos6exp3','Pos7exp4','Pos6exp4','Pos9exp2','Pos9exp3',...
    'Pos9exp1','Pos6','Pos7','Pos1exp2','Pos2exp1','Pos0'};
initialarea = flipud([2.56514721 ; 2.14046358 ; 1.73434272 ; 1.48820668 ; ...
    1.11914679 ; 0.8574703 ; 0.680720558 ; 0.636105372 ; 0.596106663 ; ...
    0.543646694 ; 0.448605372 ; 0.357986829 ; 0.300684401; 0.259265238 ; ...
    0.242155217 ; 0.234988378 ; 0.234762397 ; 0.144757231]);

LN = length(names);

total_n = 2000;
percent_holdon = 1;
n = percent_holdon * total_n;

xbar = zeros(LN,4);
s = zeros(LN,4);

tstar = tinv((1+0.95)/2 , n-1);

Fk = zeros(n,LN);
kb = zeros(n,LN);
alpha = zeros(n,LN);
rho0 = zeros(n,LN);


for i = 1:length(names)
    load(strcat('emceeinit_2000samples_',names{i},'.mat'))
    
    [sortedValues,sortIndex] = sort(minquant); %%% sort minquant vector
    minIndex = sortIndex(1:n); %%% hold on to indices of smallest n errors
    
    m = paramval'; %%% hold on to parameter values corresponding with smallest n errors
    Fk(:,i) = m(minIndex,1);
    kb(:,i) = m(minIndex,2);
    alpha(:,i) = m(minIndex,3);
    rho0(:,i) = m(minIndex,4);
end

%%% for comparison, defaults are:
%%%     alpha=0.05
%%%     Tukey-Kramer (Tukey's honest significant difference criterion)

[p_Fk,tbl_Fk,stats_Fk] = anova1(Fk,[],'off');%names);
figure
[c_Fk,meanSD_Fk,h_Fk] = multcompare(stats_Fk);
yticklabels(flip(names))

figure
scatter(initialarea,meanSD_Fk(:,1))
n = 2000;
sp = stats_Fk.s;
moe = tstar*sp/sqrt(n);
for i=1:LN
    line([initialarea(i),initialarea(i)],[meanSD_Fk(i,1)-moe,...
        meanSD_Fk(i,1)+moe])
end
xlabel('Initial Area')
ylabel('mean')

% [p_kb,tbl_kb,stats_kb] = anova1(kb);
% figure
% [c_kb,meanSD_kb,h_kb] = multcompare(stats_kb);
% yticklabels(flip(names))
% 
% [p_alpha,tbl_alpha,stats_alpha] = anova1(alpha);
% figure
% [c_alpha,meanSD_alpha,h_alpha] = multcompare(stats_alpha);
% yticklabels(flip(names))
% 
% [p_rho0,tbl_rho0,stats_rho0] = anova1(rho0);
% figure
% [c_rho0,meanSD_rho0,h_rho0] = multcompare(stats_rho0);
% yticklabels(flip(names))

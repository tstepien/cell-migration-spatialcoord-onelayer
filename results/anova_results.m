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
    
    for j = 1:4
        xbar(i,j) = mean(m(:,j));
        s(i,j) = std(m(:,j));
    end
end

%%% check to make sure it's okay to use ANOVA (pool standard deviations)
%%% (largest st dev)/(smallest st dev) < 2
if max(s(:,1))/min(s(:,1))>=2
    error('problem with standard deviations for F/k')
elseif max(s(:,2))/min(s(:,2))>=2
    error('problem with standard deviations for k/b')
elseif max(s(:,3))/min(s(:,3))>=2
    error('problem with standard deviations for alpha')
elseif max(s(:,4))/min(s(:,4))>=2
    error('problem with standard deviations for rho0')
end

%%% for comparison, defaults are:
%%%     alpha=0.05
%%%     Tukey-Kramer (Tukey's honest significant difference criterion)

asig = 0.05;

co = [0       0.4470    0.7410; ...
    0.8500    0.3250    0.0980; ...
    0.9290    0.6940    0.1250; ...
    0.4940    0.1840    0.5560; ...
    0.4660    0.6740    0.1880; ...
    0.3010    0.7450    0.9330; ...
    0.6350    0.0780    0.1840;
    0.6       0.6       0.6];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% F/k %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_Fk,tbl_Fk,stats_Fk] = anova1(Fk,[],'off');%names);
[c_Fk,meanSD_Fk,h_Fk] = multcompare(stats_Fk,'Display','off');
yticklabels(flip(names))

%%% determine compact letter display
csort_Fk = sortrows(c_Fk,6);

ind = (csort_Fk(:,6)>=asig);
samegroups_Fk = sortrows(csort_Fk(ind,1:2));

samegroups_addrepeats_Fk = sortrows([samegroups_Fk ; ...
    samegroups_Fk(:,2) , samegroups_Fk(:,1)]);

groups_Fk = {'AB','AC','D','D','AB',...
    'DE','AB','C','F','--',...
    'C','F','C','BG','EG',...
    'F','C','--'};
color_Fk = [co(1,:);co(2,:);co(3,:);co(3,:);co(1,:);...
    co(3,:);co(1,:);co(2,:);co(4,:);co(end,:);...
    co(3,:);co(4,:);co(3,:);co(5,:);co(5,:);...
    co(4,:);co(3,:);co(end,:)];

%%% boxplot
subplot(2,2,1)
boxplot(Fk,'Positions',initialarea,'Colors',color_Fk,'BoxStyle','filled',...
    'MedianStyle','target','Symbol','k+')
xlabel('Initial Area (mm^2)')
ylabel('F/k')
set(gca,'XLim',[0,initialarea(end)+initialarea(1)])
xticks('auto')
xticklabels({'0','0.5','1','1.5','2','2.5'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% k/b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_kb,tbl_kb,stats_kb] = anova1(kb,[],'off');
[c_kb,meanSD_kb,h_kb] = multcompare(stats_kb,'Display','off');
yticklabels(flip(names))

%%% determine compact letter display
csort_kb = sortrows(c_kb,6);

ind = (csort_kb(:,6)>=asig);
samegroups_kb = sortrows(csort_kb(ind,1:2));

samegroups_addrepeats_kb = sortrows([samegroups_kb ; ...
    samegroups_kb(:,2) , samegroups_kb(:,1)]);

groups_kb = {'--','A','A','BC','A',...
    'BD','C','D','EHI','E',...
    'FHJ','EJK','F','D','D',...
    'F','FIK','--'};
color_kb = [co(end,:);co(1,:);co(1,:);co(2,:);co(1,:);...
    co(2,:);co(3,:);co(4,:);co(5,:);co(5,:);...
    co(6,:);co(5,:);co(7,:);co(4,:);co(4,:);...
    co(7,:);co(7,:);co(end,:)];

%%% boxplot
subplot(2,2,2)
boxplot(kb,'Positions',initialarea,'Colors',color_kb,'BoxStyle','filled',...
    'MedianStyle','target','Symbol','k+')
xlabel('Initial Area (mm^2)')
ylabel('k/b')
set(gca,'XLim',[0,initialarea(end)+initialarea(1)])
xticks('auto')
xticklabels({'0','0.5','1','1.5','2','2.5'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_alpha,tbl_alpha,stats_alpha] = anova1(alpha,[],'off');
[c_alpha,meanSD_alpha,h_alpha] = multcompare(stats_alpha,'Display','off');
yticklabels(flip(names))

%%% determine compact letter display
csort_alpha = sortrows(c_alpha,6);

ind = (csort_alpha(:,6)>=asig);
samegroups_alpha = sortrows(csort_alpha(ind,1:2));

samegroups_addrepeats_alpha = sortrows([samegroups_alpha ; ...
    samegroups_alpha(:,2) , samegroups_alpha(:,1)]);


% [p_rho0,tbl_rho0,stats_rho0] = anova1(rho0);
% figure
% [c_rho0,meanSD_rho0,h_rho0] = multcompare(stats_rho0);
% yticklabels(flip(names))

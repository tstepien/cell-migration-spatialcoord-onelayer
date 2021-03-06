clear variables;
clc;
close all;

%%% NOTE: for Tukey's comparison, the "c" matrix outputted has the p-value
%%% in the 6th column (p-value smaller than alpha -> mean differs)
%%%
%%% grab the "samegroups_addrepeats" to manually assign compact letter
%%% display

names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6','Pos10exp1',...
    'Pos5exp4','Pos6exp3','Pos7exp4','Pos6exp4','Pos9exp2','Pos9exp3',...
    'Pos9exp1','Pos6','Pos7','Pos1exp2','Pos2exp1','Pos0'};
initialarea = flipud([2.56514721 ; 2.14046358 ; 1.73434272 ; 1.48820668 ; ...
    1.11914679 ; 0.8574703 ; 0.680720558 ; 0.636105372 ; 0.596106663 ; ...
    0.543646694 ; 0.448605372 ; 0.357986829 ; 0.300684401; 0.259265238 ; ...
    0.242155217 ; 0.234988378 ; 0.234762397 ; 0.144757231]);

LN = length(names);

total_n = 10000;
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
    load(strcat('emceeinit_10000samples_',names{i},'.mat'))
    
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
co_light = [0.4       0.7608    1; ...
    1         0.6039    0.4353; ...
    1         0.8784    0.5843; ...
    0.7804    0.5843    0.8196; ...
    0.7569    0.8627    0.6196;
    0.7       0.7       0.7];
co_dark = [0.4     0.4     0.4; ... %dark gray
    0       0.2980  0.4941; ... %blue
    0.7647  0.5412  0; ... %orange
    0.3059  0       0.3686; ... %purple
    0.1961  0.3451  0; ... %green
    0       0.5020  0.7176; ... %lighter blue
    0.6941   0.2078  0]; %red

fs_label = 20;
fs_ticks = 14;
fs_groups = 14;

psv = 0.1;
psh = 0.07;
pmb = 0;
pmt = 0.06;
pml = 0;
pmr = 0.005;

ispread = [0,-0.045,-0.025,-0.01,0,0,0,0,-0.01,0,0.02,0.05,0,0,0,0,0,0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% F/k %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_Fk,tbl_Fk,stats_Fk] = anova1(Fk,[],'off');%names);
[c_Fk,meanSD_Fk,h_Fk] = multcompare(stats_Fk,'Display','off');
% yticklabels(flip(names))

%%% determine compact letter display
csort_Fk = sortrows(c_Fk,6);

ind = (csort_Fk(:,6)>=asig);
samegroups_Fk = sortrows(csort_Fk(ind,1:2));

samegroups_addrepeats_Fk = sortrows([samegroups_Fk ; ...
    samegroups_Fk(:,2) , samegroups_Fk(:,1)]);

groups_Fk = {'AB','CD','E','E','AB',...
    '***','AC','DF','***','***',...
    'FG','***','G','B','***',...
    '***','G','***'};
color_Fk = [co_light(1,:);co_light(2,:);co_light(3,:);co_light(3,:);co_light(1,:);...
    co_light(end,:);co_light(1,:);co_light(2,:);co_light(end,:);co_light(end,:);...
    co_light(4,:);co_light(end,:);co_light(4,:);co_light(1,:);co_light(end,:);...
    co_light(end,:);co_light(4,:);co_light(end,:)];

%%% boxplot
subaxis(2,2,1,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt-0.015,'ml',pml,'mr',pmr)
boxplot(Fk,'Positions',initialarea,'Colors',color_Fk,'BoxStyle','filled',...
    'MedianStyle','target','Symbol','k+')
% % % set(gca,'XLim',[0,initialarea(end)+initialarea(1)],'FontSize',fs_ticks)
% % % xticks('auto')
% % % xticklabels({'0','0.5','1','1.5','2','2.5'})
set(gca,'FontSize',fs_ticks)
set(gca,'XScale','log');
xlim([0.1,4])
xticks('auto')
xticklabels('') %xticklabels('auto')
% xlabel('Initial Area (mm^2)','FontSize',fs_label)
ylabel('$F/k$','Interpreter','latex','FontSize',fs_label)

for i=1:LN
    text(initialarea(i)+ispread(i),1.58,groups_Fk{i},'Color',color_Fk(i,:),...
        'FontSize',fs_groups,'Rotation',90)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% k/b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_kb,tbl_kb,stats_kb] = anova1(kb,[],'off');
[c_kb,meanSD_kb,h_kb] = multcompare(stats_kb,'Display','off');
% yticklabels(flip(names))

%%% determine compact letter display
csort_kb = sortrows(c_kb,6);

ind = (csort_kb(:,6)>=asig);
samegroups_kb = sortrows(csort_kb(ind,1:2));

samegroups_addrepeats_kb = sortrows([samegroups_kb ; ...
    samegroups_kb(:,2) , samegroups_kb(:,1)]);

groups_kb = {'***','A','A','***','A',...
    'B','***','C','D','***',...
    'E','D','E','C','BC',...
    'DF','EF','***'};
color_kb = [co(end,:);co(1,:);co(1,:);co(end,:);co(1,:);...
    co(2,:);co(end,:);co(3,:);co(4,:);co(end,:);...
    co(5,:);co(4,:);co(5,:);co(3,:);co(2,:);...
    co(4,:);co(5,:);co(end,:)];

%%% boxplot
subaxis(2,2,2,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt-0.015,'ml',pml,'mr',pmr)
boxplot(kb,'Positions',initialarea,'Colors',color_kb,'BoxStyle','filled',...
    'MedianStyle','target','Symbol','k+')
% % % set(gca,'XLim',[0,initialarea(end)+initialarea(1)])
% % % xticks('auto')
% % % xticklabels({'0','0.5','1','1.5','2','2.5'})
set(gca,'FontSize',fs_ticks)
set(gca,'XScale','log');
xlim([0.1,4])
xticks('auto')
xticklabels('') %xticklabels('auto')
% xlabel('Initial Area (mm^2)','FontSize',fs_label)
ylabel('$k/b$','Interpreter','latex','FontSize',fs_label)

for i=1:LN
    text(initialarea(i)+ispread(i),5240,groups_kb{i},'Color',color_kb(i,:),...
        'FontSize',fs_groups,'Rotation',90)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_alpha,tbl_alpha,stats_alpha] = anova1(alpha,[],'off');
[c_alpha,meanSD_alpha,h_alpha] = multcompare(stats_alpha,'Display','off');
% yticklabels(flip(names))

%%% determine compact letter display
csort_alpha = sortrows(c_alpha,6);

ind = (csort_alpha(:,6)>=asig);
samegroups_alpha = sortrows(csort_alpha(ind,1:2));

samegroups_addrepeats_alpha = sortrows([samegroups_alpha ; ...
    samegroups_alpha(:,2) , samegroups_alpha(:,1)]);

groups_alpha = {'AB','CD','CE','E','ABDF',...
    'CFGH','CFG','CGH','ABD','A',...
    'CFGH','ABDGI','CHI','EHJ','CJ',...
    'ABDGI','CHI','***'};
color_alpha = [co_light(5,:);co_dark(2,:);co_dark(2,:);co_dark(4,:);co_light(5,:);...
    co_dark(2,:);co_dark(2,:);co_dark(2,:);co_light(5,:);co_light(5,:);...
    co_dark(2,:);co_light(5,:);co_dark(2,:);co_dark(4,:);co_dark(2,:);...
    co_light(5,:);co_dark(2,:);co_dark(1,:)];

%%% boxplot
subaxis(2,2,3,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt,'ml',pml,'mr',pmr)
boxplot(alpha,'Positions',initialarea,'Colors',color_alpha,'BoxStyle','filled',...
    'MedianStyle','target','Symbol','k+')
% % % set(gca,'XLim',[0,initialarea(end)+initialarea(1)])
% % % xticks('auto')
% % % xticklabels({'0','0.5','1','1.5','2','2.5'})
set(gca,'FontSize',fs_ticks)
set(gca,'XScale','log');
xlim([0.1,4])
xticks('auto')
xticklabels('auto')
xlabel('Initial Area (mm$^2$)','Interpreter','latex','FontSize',fs_label)
ylabel('$\alpha$','Interpreter','latex','FontSize',fs_label)

for i=1:LN
    text(initialarea(i)+ispread(i),1.05,groups_alpha{i},'Color',color_alpha(i,:),...
        'FontSize',fs_groups,'Rotation',90)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% rho0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_rho0,tbl_rho0,stats_rho0] = anova1(rho0,[],'off');
[c_rho0,meanSD_rho0,h_rho0] = multcompare(stats_rho0,'Display','off');
% yticklabels(flip(names))

%%% determine compact letter display
csort_rho0 = sortrows(c_rho0,6);

ind = (csort_rho0(:,6)>=asig);
samegroups_rho0 = sortrows(csort_rho0(ind,1:2));

samegroups_addrepeats_rho0 = sortrows([samegroups_rho0 ; ...
    samegroups_rho0(:,2) , samegroups_rho0(:,1)]);

groups_rho0 = {'A','B','A','AB','AB',...
    'B','AB','C','DE','D',...
    'CE','DE','CF','C','C',...
    'DEF','D','***'};
color_rho0 = [co_dark(3,:);co_dark(4,:);co_dark(3,:);co_dark(3,:);co_dark(3,:);...
    co_dark(4,:);co_dark(3,:);co_dark(5,:);co_dark(6,:);co_dark(6,:);...
    co_dark(5,:);co_dark(6,:);co_dark(5,:);co_dark(5,:);co_dark(5,:);...
    co_dark(6,:);co_dark(6,:);co_dark(1,:)];

%%% boxplot
subaxis(2,2,4,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt,'ml',pml,'mr',pmr)
boxplot(rho0,'Positions',initialarea,'Colors',color_rho0,'BoxStyle','filled',...
    'MedianStyle','target','Symbol','k+')
% % % set(gca,'XLim',[0,initialarea(end)+initialarea(1)])
% % % xticks('auto')
% % % xticklabels({'0','0.5','1','1.5','2','2.5'})
set(gca,'FontSize',fs_ticks)
set(gca,'XScale','log');
xlim([0.1,4])
xticks('auto')
xticklabels('auto')
xlabel('Initial Area (mm$^2$)','Interpreter','latex','FontSize',fs_label)
ylabel('$\rho_\mathrm{unstressed}$','Interpreter','latex','FontSize',fs_label)

for i=1:LN
    text(initialarea(i)+ispread(i),2055,groups_rho0{i},'Color',color_rho0(i,:),...
        'FontSize',fs_groups,'Rotation',90)
end

set(gcf,'Units','inches','Position',[2,2,14,7],'PaperPositionMode','auto')
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

co = [
    0.8       0.4       1; ...
    0.6       0.6       0.6;
    0.8500    0.3250    0.0980; ...
    0         0.4470    0.7410; ...
    0.9290    0.6940    0.1250; ...
    0.6350    0.0780    0.1840; ...
    0.3010    0.7450    0.9330; ...
    0.4660    0.6740    0.1880; ...
    1         0.8       0.6; ...
    0         0.4       0; ...
    0.4940    0.1840    0.5560; ...
    1         1         0.4; ...
    0         0         0];

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

groups = {'Ia','Ia','Ia','Ia','Ia','Ib','Ib','Ib','Ib','Ib','Ib','Ib','II','II','II','III','III','III'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% F/k %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_Fk,tbl_Fk,stats_Fk] = anova1(Fk,groups,'off');%names);
[c_Fk,meanSD_Fk,h_Fk] = multcompare(stats_Fk,'Display','off');

color_Fk = [co(1,:);co(2,:);co(3,:);co(4,:)];

%%% boxplot
subaxis(2,2,1,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt,'ml',pml,'mr',pmr)
boxplot(Fk,groups,'Colors','k','Symbol','k+');
h1 = gca;
h1.XAxis.TickLabelInterpreter = 'latex';
h2 = findobj(gca,'Tag','Box');
for j=1:length(h2)
    patch(get(h2(j),'XData'),get(h2(j),'YData'),color_Fk(j,:),'FaceAlpha',.5);
end
set(gca,'FontSize',fs_ticks)
ylabel('$F/k$','Interpreter','latex','FontSize',fs_label)

text(1.025,0.652+0.03,'***','FontSize',fs_groups)
text(2.025,0.7876+0.03,'***','FontSize',fs_groups)
text(3.025,0.7094+0.03,'***','FontSize',fs_groups)
text(4.025,0.8642+0.03,'***','FontSize',fs_groups)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% k/b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_kb,tbl_kb,stats_kb] = anova1(kb,groups,'off');
[c_kb,meanSD_kb,h_kb] = multcompare(stats_kb,'Display','off');

color_kb = [co(5,:);co(6,:);co(7,:);co(8,:)];

%%% boxplot
subaxis(2,2,2,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt,'ml',pml,'mr',pmr)
boxplot(kb,groups,'Colors','k')
h1 = gca;
h1.XAxis.TickLabelInterpreter = 'latex';
h2 = findobj(gca,'Tag','Box');
for j=1:length(h2)
    patch(get(h2(j),'XData'),get(h2(j),'YData'),color_kb(j,:),'FaceAlpha',.5);
end
set(gca,'FontSize',fs_ticks)
ylabel('$k/b$','Interpreter','latex','FontSize',fs_label)

text(1.025,2663+80,'***','FontSize',fs_groups)
text(2.025,3485+80,'***','FontSize',fs_groups)
text(3.025,3391+80,'***','FontSize',fs_groups)
text(4.025,3697+80,'***','FontSize',fs_groups)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_alpha,tbl_alpha,stats_alpha] = anova1(alpha,groups,'off');
[c_alpha,meanSD_alpha,h_alpha] = multcompare(stats_alpha,'Display','off');

color_alpha = [co(9,:);co(10,:);co(9,:);co(10,:)];

%%% boxplot
subaxis(2,2,3,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt,'ml',pml,'mr',pmr)
boxplot(alpha,groups,'Colors','k')
h1 = gca;
h1.XAxis.TickLabelInterpreter = 'latex';
h2 = findobj(gca,'Tag','Box');
for j=1:length(h2)
    patch(get(h2(j),'XData'),get(h2(j),'YData'),color_alpha(j,:),'FaceAlpha',.5);
end
set(gca,'FontSize',fs_ticks)
ylabel('$\alpha$','Interpreter','latex','FontSize',fs_label)

text(1.025,0.715+0.04,'AB','FontSize',fs_groups)
text(2.025,0.7132+0.04,'B','FontSize',fs_groups)
text(3.025,0.6849+0.04,'A','FontSize',fs_groups)
text(4.025,0.713+0.04,'B','FontSize',fs_groups)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% rho0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p_rho0,tbl_rho0,stats_rho0] = anova1(rho0,groups,'off');
[c_rho0,meanSD_rho0,h_rho0] = multcompare(stats_rho0,'Display','off');

color_rho0 = [co(11,:);co(12,:);co(12,:);co(13,:)];

%%% boxplot
subaxis(2,2,4,'sv',psv,'sh',psh,'mb',pmb,'mt',pmt,'ml',pml,'mr',pmr)
boxplot(rho0,groups,'Colors','k')
h1 = gca;
h1.XAxis.TickLabelInterpreter = 'latex';
h2 = findobj(gca,'Tag','Box');
for j=1:length(h2)
    patch(get(h2(j),'XData'),get(h2(j),'YData'),color_rho0(j,:),'FaceAlpha',.5);
end
set(gca,'FontSize',fs_ticks)
ylabel('$\rho_\mathrm{unstressed}$','Interpreter','latex','FontSize',fs_label)

text(1.025,1774+20,'***','FontSize',fs_groups)
text(2.025,1739+40,'A','FontSize',fs_groups)
text(3.025,1744+40,'A','FontSize',fs_groups)
text(4.025,1703+20,'***','FontSize',fs_groups)

set(gcf,'Units','inches','Position',[2,2,14,7],'PaperPositionMode','auto')
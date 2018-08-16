clear variables;
clc;
% close all;

names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6','Pos10exp1',...
    'Pos5exp4','Pos6exp3','Pos7exp4','Pos6exp4','Pos9exp2','Pos9exp3',...
    'Pos9exp1','Pos6','Pos7','Pos1exp2','Pos2exp1','Pos0'};
initialarea = flipud([2.56514721 ; 2.14046358 ; 1.73434272 ; 1.48820668 ; ...
    1.11914679 ; 0.8574703 ; 0.680720558 ; 0.636105372 ; 0.596106663 ; ...
    0.543646694 ; 0.448605372 ; 0.357986829 ; 0.300684401; 0.259265238 ; ...
    0.242155217 ; 0.234988378 ; 0.234762397 ; 0.144757231]);

LN = length(names);

total_n = 10000;
percent_holdon = 0.2;%0.2;
n = percent_holdon * total_n;

Fk = zeros(n,LN);
kb = zeros(n,LN);
alpha = zeros(n,LN);
rho0 = zeros(n,LN);

correlation = zeros(4,4,LN);

cov_Fkkb = zeros(LN,1);
cov_Fkalpha = zeros(LN,1);
cov_Fkrho0 = zeros(LN,1);
cov_kbalpha = zeros(LN,1);
cov_kbrho0 = zeros(LN,1);
cov_alpharho0 = zeros(LN,1);

for i = 1:length(names)
    load(strcat('emceeinit_10000samples_',names{i},'.mat'))
    
    [sortedValues,sortIndex] = sort(minquant); %%% sort minquant vector
    minIndex = sortIndex(1:n); %%% hold on to indices of smallest n errors
    
    m = paramval'; %%% hold on to parameter values corresponding with smallest n errors
    param = m(minIndex,:);
    Fk(:,i) = m(minIndex,1);
    kb(:,i) = m(minIndex,2);
    alpha(:,i) = m(minIndex,3);
    rho0(:,i) = m(minIndex,4);
    
    correlation(:,:,i) = corrcoef(param);
    
    c = cov(Fk(:,i),kb(:,i));       cov_Fkkb(i) = c(1,2);
    c = cov(Fk(:,i),alpha(:,i));    cov_Fkalpha(i) = c(1,2);
    c = cov(Fk(:,i),rho0(:,i));     cov_Fkrho0(i) = c(1,2);
    c = cov(kb(:,i),alpha(:,i));    cov_kbalpha(i) = c(1,2);
    c = cov(kb(:,i),rho0(:,i));     cov_kbrho0(i) = c(1,2);
    c = cov(alpha(:,i),rho0(:,i));  cov_alpharho0(i) = c(1,2);
end

co = [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

fs_label = 20;
fs_ticks = 16;
fs_text = 16;
lw = 1.5;
ms = 8;

%% correlation
corr_Fkkb = squeeze(correlation(1,2,:));
corr_Fkalpha = squeeze(correlation(1,3,:));
corr_Fkrho0 = squeeze(correlation(1,4,:));
corr_kbalpha = squeeze(correlation(2,3,:));
corr_kbrho0 = squeeze(correlation(2,4,:));
corr_alpharho0 = squeeze(correlation(3,4,:));

disp('Average correlation over all explants')
corrTable = table([mean(corr_Fkkb);mean(corr_Fkalpha);mean(corr_Fkrho0)],...
    [0;mean(corr_kbalpha);mean(corr_kbrho0)],[0;0;mean(corr_alpharho0)],...
    'RowNames',{'kb','alpha','rho0'},'VariableNames',{'Fk','kb','alpha'})

hold on
line([0,3],[0,0],'LineStyle','--','Color',[0.5,0.5,0.5])
line([0,3],[0.5,0.5],'LineStyle','--','Color',[0.5,0.5,0.5])
line([0,3],[-0.5,-0.5],'LineStyle','--','Color',[0.5,0.5,0.5])
h1 = plot(initialarea,corr_Fkkb,'-o','Color',co(1,:),'LineWidth',lw,...
    'MarkerSize',ms,'MarkerFaceColor','auto');
h2 = plot(initialarea,corr_Fkalpha,'-+','Color',co(2,:),'LineWidth',lw,...
    'MarkerSize',ms,'MarkerFaceColor','auto');
h3 = plot(initialarea,corr_Fkrho0,'-d','Color',co(3,:),'LineWidth',lw,...
    'MarkerSize',ms,'MarkerFaceColor','auto');
h4 = plot(initialarea,corr_kbalpha,'-s','Color',co(4,:),'LineWidth',lw,...
    'MarkerSize',ms,'MarkerFaceColor','auto');
h5 = plot(initialarea,corr_kbrho0,'-x','Color',co(5,:),'LineWidth',lw,...
    'MarkerSize',ms,'MarkerFaceColor','auto');
h6 = plot(initialarea,corr_alpharho0,'-*','Color',co(6,:),'LineWidth',lw,...
    'MarkerSize',ms,'MarkerFaceColor','auto');
hold off

xval = 2.65;
text(xval,mean(corr_Fkkb),num2str(mean(corr_Fkkb),2),'Color',co(1,:),...
    'FontSize',fs_text)
text(xval,mean(corr_Fkalpha)-0.025,num2str(mean(corr_Fkalpha),2),'Color',co(2,:),...
    'FontSize',fs_text)
text(xval,mean(corr_Fkrho0)+0.025,num2str(mean(corr_Fkrho0),2),'Color',co(3,:),...
    'FontSize',fs_text)
text(xval,mean(corr_kbalpha)+0.0125,num2str(mean(corr_kbalpha),2),'Color',co(4,:),...
    'FontSize',fs_text)
text(xval,mean(corr_kbrho0),num2str(mean(corr_kbrho0),2),'Color',co(5,:),...
    'FontSize',fs_text)
text(xval,mean(corr_alpharho0)+0.0025,num2str(mean(corr_alpharho0),2),'Color',co(6,:),...
    'FontSize',fs_text)
    
box on
hselect = [h1,h2,h3,h4,h5,h6];
legend(hselect,{'$F/k$ and $k/b$','$F/k$ and $\alpha$',...
    '$F/k$ and $\rho_\mathrm{unstressed}$','$k/b$ and $\alpha$',...
    '$k/b$ and $\rho_\mathrm{unstressed}$','$\alpha$ and $\rho_\mathrm{unstressed}$'},...
    'Location','EastOutside','Interpreter','latex',...
    'Position',[0.76476 0.3968 0.2320 0.2623])
ylim([-1,1])
%xlim([0,2.75])
set(gca,'YTick',-1:0.25:1,'FontSize',fs_ticks,...
    'Position',[0.13 0.13 0.6245 0.8585])
xlabel('Initial Area (mm$^2$)','Interpreter','latex','FontSize',fs_label)
ylabel('Correlation Coefficient','Interpreter','latex','FontSize',fs_label)
set(gcf,'Position',[440 378 660 420])

%% covariance

disp('Average covariance over all explants')
covTable = table([mean(cov_Fkkb);mean(cov_Fkalpha);mean(cov_Fkrho0)],...
    [0;mean(cov_kbalpha);mean(cov_kbrho0)],[0;0;mean(cov_alpharho0)],...
    'RowNames',{'kb','alpha','rho0'},'VariableNames',{'Fk','kb','alpha'})

figure
subplot(1,3,1)
hold on
plot(1:LN,cov_Fkalpha,'-+','Color',co(2,:))
plot(1:LN,cov_Fkrho0,'-d','Color',co(3,:))
plot(1:LN,cov_kbalpha,'-s','Color',co(4,:))
plot(1:LN,cov_alpharho0,'-*','Color',co(6,:))
hold off
xlabel('Explant #')
ylabel('covariance')
legend('Fk and alpha','Fk and rho0','kb and alpha',...
    'alpha and rho0')

subplot(1,3,2)
hold on
plot(1:LN,cov_Fkkb,'-o','Color',co(1,:))
hold off
xlabel('Explant #')
ylabel('covariance')
legend('Fk and kb')

subplot(1,3,3)
plot(1:LN,cov_kbrho0,'-x','Color',co(5,:))
xlabel('Explant #')
ylabel('covariance')
legend('kb and rho0')

set(gcf,'Units','inches','Position',[2,2,12,4],'PaperPositionMode','auto')
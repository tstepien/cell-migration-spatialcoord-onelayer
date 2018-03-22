%%
figure
ecornerplot(models,'names',{'F/k','k/b','alpha','rho0'},'ks',true)

%%
figure
eacorr(models)

%%
[C,lags,ESS]=eacorr(models);

set(groot,'defaultAxesLineStyleOrder','-|--|:')

figure

subplot(2,3,1)
Fk = squeeze(models(1,:,:));
plot(lags,Fk)
xlabel('lags')
ylabel('F/k')

subplot(2,3,2)
kb = squeeze(models(2,:,:));
plot(lags,kb)
xlabel('lags')
ylabel('k/b')
legend('1','2','3','4','5','6','7','8','Location','eastoutside')

subplot(2,3,4)
alpha = squeeze(models(3,:,:));
plot(lags,alpha)
xlabel('lags')
ylabel('alpha')

subplot(2,3,5)
rho0 = squeeze(models(4,:,:));
plot(lags,rho0)
xlabel('lags')
ylabel('rho_{unstressed}')



subplot(2,3,6)
logPsq = squeeze(logP(2,:,:));
plot(lags,logPsq);
xlabel('lags')
ylabel('logP')


set(gcf,'Units','centimeters','Position',[0,25,50,20])
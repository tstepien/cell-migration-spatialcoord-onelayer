function [models,logP] = myemceerun63

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [1.08726109488477,1.26339278744364,1.29315413648470,1.23341270512600,1.29089774836151,1.73160066396014,1.29769636610412,1.66644565903157;...
    4168.06864362187,3700.64493773121,4029.27771655539,4096.03454664985,3977.08822691816,4024.94080327100,4108.43113287097,4028.88156908879;...
    1.47778724298801,2.16280286961539,0.916197320643922,1.37517911613782,1.57314061651495,1.08463914924724,1.51747753155491,0.705686062962056;...
    1332.76785688127,1277.22959187360,1419.08782549045,1516.04193942320,1351.98953881823,1473.14904834604,1369.06750386036,1450.59492657127];

%%% prior - all 4 parameters need to be positive
%%%       - cell boundary cannot go beyond the computational domain
logprior = @(m) (m(1)>0) && (m(2)>0) && (m(3)>0) && (m(4)>0) ...
    && (time.simulation_end_early==0) && (centerdensincrease==0);

%%% likelihood
% this is based on the error function
loglike = @likelihoodfunc;

%%% prior and likelihood
logPfuns = {logprior loglike};

%%% apply the MCMC hammer
[models,logP] = gwmcmc(minit,logPfuns,100000);
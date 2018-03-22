function [models,logP] = myemceerun64

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [5.15158402809410,5.75743771764398,0.00369117494035205,0.00347640777264277,0.00386820526167121,0.000621698945168426,4.97840452012967,6.37812775309084e-05;...
    2336.64709225824,2055.18821734386,136.787226117455,1143.76223428108,2142.53750814120,5966.78106292082,2547.69194959797,517.340514260332;...
    1.93724718866198,2.19354173695026,20.8524205718349,9.53028635229759,10.6602129904188,32.0218366230236,3.45794918118313,5.62648669532151;...
    1986.21868431751,1859.02463864034,1855.45881708051,1907.93906238521,2392.22069441242,4764.02097706972,2401.67803062185,1715.82526096246];

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
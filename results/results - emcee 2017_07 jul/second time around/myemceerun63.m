function [models,logP] = myemceerun63

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [1.08726109488477,1.67703730068328,1.29447816236149,1.23341270512600,1.04835130833711,1.58773329057486,1.63382921800536,1.67536093369036;...
    4168.06864362187,3849.63645674653,4027.12086994594,4096.03454664985,4053.02847512951,4077.81764314606,4059.40121481945,4034.14988405043;...
    1.47778724298801,1.18724389736794,0.447075926716179,1.37517911613782,1.21466105362548,0.593830415060441,0.951052443238319,0.615185987340387;...
    1332.76785688127,1399.63465233704,1461.68027956452,1516.04193942320,1383.07445794976,1502.66955544713,1452.91036655469,1461.71979564186];

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
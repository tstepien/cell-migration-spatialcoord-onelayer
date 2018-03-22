function [models,logP] = myemceerun21

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [0.0349683556488613,2.83283951319860,2.14225589071345,2.29906766252940,0.0156568904276545,0.00149250221582431,2.79683931212527,2.74902508398069;...
    1947.60536623750,1937.44151798467,2507.43352155069,2445.19323652513,1978.18143693114,2482.39252480411,2344.40439677010,2055.63085666662;...
    0.958739639187225,3.81261586255055,5.01717704714605,1.53563856322558,0.789462464141287,4.21622205006229,0.0384885747212764,2.25756659157035;...
    2001.29071087080,1559.46437379861,1694.57987340530,1891.13818194604,2006.76097965303,1791.66948800469,1824.02925488016,1826.71354565698];

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
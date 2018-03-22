function [models,logP] = myemceerun74

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [3.96778008350948,2.67459122683373,2.14268111946268,3.26606191824124,0.0218579096990470,0.000746703344415785,3.12414249183136,3.35527736980852;...
    1789.85477165587,2304.55140267511,2584.53779216283,2048.80738743679,2006.52169476489,1995.50211367703,2074.79817930900,2005.26571761905;...
    4.39004538303536,2.28357711175847,2.16404971482834,1.12187370773273,0.808960949794943,1.32314617701006,1.79681377469471,2.04909305330842;...
    1970.07186651704,1338.08418816486,1236.57107989693,1621.71530187520,1502.70987669662,1468.69816561526,1557.37780302866,1645.27054322443];

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
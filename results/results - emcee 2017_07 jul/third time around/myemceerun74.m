function [models,logP] = myemceerun74

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [3.93085468035043,2.49335748469270,2.14268111946268,3.42624534854537,0.0114249762688976,0.000759767023907652,2.27417793168130,3.42512411301760;...
    1803.47495867669,2394.53260343535,2584.53779216283,1984.44233155103,2001.07593510594,1995.50893262774,2449.57360889944,1976.05358273913;...
    4.21613009633667,2.23627438496380,2.16404971482834,1.56078235467001,1.06306581505883,1.32282799760833,1.54301951927930,2.53306243628065;...
    1951.72409044716,1287.88182024374,1236.57107989693,1689.32853028105,1485.90165116954,1468.71921216680,1215.24925461118,1673.22001211281];

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
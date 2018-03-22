function [models,logP] = myemceerun6

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [2.38681519027956,2.12533314787415,2.30478994880205,2.26211284721766,0.0379594992339007,0.00440363183811376,1.01186543866972,2.32017198886957;...
    2019.86943975939,2233.33139098797,2079.08018201545,2045.53328331338,1994.97447652476,1974.59024738669,1930.47901096402,2047.15846179283;...
    1.93189687349936,1.80850992882472,1.33428985641200,0.651324280665099,0.864918476442813,1.25800268072061,1.48464885595374,1.26135397057302;...
    2024.25277594883,2049.48924032872,2030.80715611721,2021.03440242464,1993.73955639980,1967.49656725318,1865.88073645042,2003.57486439195];

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
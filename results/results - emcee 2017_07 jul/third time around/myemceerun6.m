function [models,logP] = myemceerun6

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [2.72254376417415,1.37387339250584,2.30886808673166,2.14704756294971,2.31406877517588,0.00440363183811376,0.966084304243110,2.36971321369585;...
    1788.40625393408,2999.61639981615,2076.13633729783,2223.72190841266,2062.80982727077,1974.59024738669,1926.39608588625,2020.11493044299;...
    3.09402447474766,5.10604251805275,1.36400173289642,2.01408951426367,1.78337638022046,1.25800268072061,1.49246253934685,1.65307386604935;...
    2008.99029193989,2150.96779661742,2030.48128488674,2053.55242285639,2049.27637496609,1967.49656725318,1861.06245179069,2004.83686996559];

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
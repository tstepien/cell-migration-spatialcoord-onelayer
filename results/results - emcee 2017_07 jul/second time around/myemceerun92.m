function [models,logP] = myemceerun92

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [2.70223742824717,2.60427290643993,1.81390030084646,2.09727794166823,0.0292994656964196,0.945278619263777,1.06955082529786,2.87683340576856;...
    2130.20113001958,2140.43102467362,2757.72850376346,2105.80280429113,1872.16436956890,1992.10795640210,1855.13157617886,1968.83398672635;...
    3.39772031463450,2.16628149876692,2.98102353490219,0.384817294618106,1.21205102046407,2.26059392413430,1.79688859696085,2.15108121985971;...
    1642.88389848175,1561.87992962773,1595.13474209302,1585.76905397632,1356.67522433203,1401.59743132144,1328.42003052954,1568.46823950047];

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
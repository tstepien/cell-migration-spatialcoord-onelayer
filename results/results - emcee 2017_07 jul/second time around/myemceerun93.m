function [models,logP] = myemceerun93

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [2.56058393964259,2.04527988659778,2.72982267469831,1.46105339865194,0.0141136040603822,0.0197418721689777,2.18627444225603,2.04239200976616;...
    2020.12642677572,2200.39153599958,1896.97545642103,2031.39229921778,1994.89267618168,1907.57354060753,2146.13565016117,2066.34244819766;...
    2.06912712293867,1.48857114158281,2.19379732543847,0.989984555293823,1.31994756164842,5.18647964702310,1.39713595692799,0.803898480881390;...
    1642.91799471006,1418.85309931314,1586.69430220877,1400.90116418844,1480.88798562435,1293.58252639906,1469.04185456688,1306.47977173844];

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
function [models,logP] = myemceerun21

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [0.0239900641581739,3.06459372790744,1.29171168097683,2.40307138795169,0.000241280845569396,0.00149590674881493,2.23975915881603,2.54682535296545;...
    2110.58578500697,1694.66473093070,2296.79010960200,2344.71830248238,2249.02567578441,2482.07825705481,2347.97470967038,2236.59660488247;...
    1.93561868272184,5.68701676622584,3.35727774649827,2.05897807530293,2.47065803720509,4.21397535942923,1.26875439032930,1.94371244282585;...
    1938.18591018455,1259.72555524270,1817.85045301047,1812.55768649190,1899.05438973641,1791.80899345898,1823.79487295910,1852.48974609131];

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
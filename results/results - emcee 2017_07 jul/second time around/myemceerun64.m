function [models,logP] = myemceerun64

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [4.86980312200069,5.73084963214232,0.00325391811126330,0.00227209618123312,0.0175684087832672,0.00285303971311580,4.97853556184367,0.000148428329098966;...
    2455.87644461203,2071.96373318242,1694.31425601159,1259.80877797050,993.396399776382,1840.83931092687,2544.40995867729,544.375519379870;...
    1.67552653990865,2.23628734018181,9.81240913984630,4.58775510626875,3.37893622908627,9.31070805760673,3.41868866086561,2.45898260614503;...
    2011.48018878728,1877.44811504430,2145.86593069658,1758.57652780677,1669.96284405741,2233.54797666768,2392.29976688442,1480.04955370728];

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
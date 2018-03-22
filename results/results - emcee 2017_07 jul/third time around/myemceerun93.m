function [models,logP] = myemceerun93

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [2.56673592661324,1.35467104800788,2.76536142588928,1.51867836394088,0.0168950342409995,0.0197383893793431,1.55276539695683,1.74930799058627;...
    2015.64977333822,2169.34323841281,1871.11475914673,2062.13953048579,1951.74048898213,1907.62757395747,2113.56401932056,2043.34454446511;...
    2.07365900189153,2.06104343379338,2.21997704904672,1.16804476937171,3.23074655506556,5.18408702506395,2.35915972887284,1.43859107004020;...
    1640.87421068156,1435.19129554487,1574.88778629394,1393.58543771365,1388.32362173274,1293.69843159393,1396.12545129459,1304.62774601228];

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
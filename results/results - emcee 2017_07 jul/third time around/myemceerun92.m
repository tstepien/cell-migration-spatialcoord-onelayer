function [models,logP] = myemceerun92

global time centerdensincrease;

%%% initialize indicators for prior
time.simulation_end_early = 0;
centerdensincrease = 0;

minit = [2.55073504766830,2.60427290643993,1.62335129494539,2.10853016983725,1.01043536802504,0.945278619263777,1.22782547324816,2.86886342854001;...
    2287.85201547620,2140.43102467362,2929.78852483886,2109.65467569700,1906.84377624239,1992.10795640210,2004.44639115294,1976.20009261115;...
    4.51339918063746,2.16628149876692,3.15596333919521,0.366448202386412,1.91710367839842,2.26059392413430,2.13886492419336,2.20798794439384;...
    1703.01917009801,1561.87992962773,1604.96542381783,1589.92564027763,1349.47743028128,1401.59743132144,1328.55537897513,1571.86517404586];

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
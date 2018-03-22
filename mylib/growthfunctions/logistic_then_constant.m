function [C_new,newmassadded] = logistic_then_constant(param,C_old,dt,t,massadded)
% [C_new,newmassadded] = logistic_then_constant(param,C_old,dt,t,massadded)
%
% Logistic growth function q(p) = alpha*p*(1-p/rho_k)
% first and then 
% Constant growth function q(p) = alpha
% after t=6hrs
%
% Inputs:
%   param     = parameters (structure with Fk,kb,alpha) - note that
%               Fk = F/k and kb = k/b due to parameter identifiability
%   C_old     = density before adding growth
%   dt        = time step size
%   t         = current time
%   massadded = total mass added to the layer from all previous steps
%
% Outputs:
%   C_new        = density after adding growth
%   newmassadded = mass added to layer during this step

global g;

if t<6
    rho_k = exp(param.Fk)*param.rho0;
    C_new = C_old + param.alpha.*C_old.*(1-C_old/rho_k).*dt;

    newmassadded = sum(sum(param.alpha.*C_old.*(1-C_old/rho_k).*dt))*g.dx*g.dy;
else
    C_new = C_old + param.alpha.*(C_old>0).*dt;
                       
    newmassadded = sum(sum(param.alpha.*(C_old>0).*dt))*g.dx*g.dy;
end
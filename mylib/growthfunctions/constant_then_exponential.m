function [C_new,newmassadded] = constant_then_exponential(param,C_old,dt,t,massadded)
% [C_new,newmassadded] = constant_then_exponential(param,C_old,dt,t,massadded)
%
% Constant growth function q(p) = alpha
% first and then 
% Exponential growth function q(p) = alpha*p
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
    C_new = C_old + param.alpha.*(C_old>0).*dt;

    newmassadded = sum(sum(param.alpha.*(C_old>0).*dt))*g.dx*g.dy;
else
    C_new = C_old + param.alpha.*C_old.*dt;

    newmassadded = sum(sum(param.alpha.*C_old.*dt))*g.dx*g.dy;
end
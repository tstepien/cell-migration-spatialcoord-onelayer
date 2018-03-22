function [C_new,newmassadded] = exponential_fulltime_origcolony(param,C_old,dt,t,massadded,Phi0)
% [C_new,newmassadded] = exponential_fulltime_origcolong(param,C_old,dt,t,massadded,Phi0)
%
% Exponential growth function q(p) = alpha*p
% for entire simulation time
% only where cell colony originally was located
%
% Inputs:
%   param     = parameters (structure with Fk,kb,alpha) - note that
%               Fk = F/k and kb = k/b due to parameter identifiability
%   C_old     = density before adding growth
%   dt        = time step size
%   t         = current time
%   massadded = total mass added to the layer from all previous steps
%   Phi0      = level set for initial cell colony
%
% Outputs:
%   C_new        = density after adding growth
%   newmassadded = mass added to layer during this step

global g;

C_new = C_old + param.alpha.*C_old.*dt.*(Phi0>0);

newmassadded = sum(sum(param.alpha.*C_old.*dt.*(Phi0>0)))*g.dx*g.dy;
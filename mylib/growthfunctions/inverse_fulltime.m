function [C_new,newmassadded] = inverse_fulltime(param,C_old,dt,t,massadded)
% [C_new,newmassadded] = inverse_fulltime(param,C_old,dt,t,massadded)
%
% Inverse growth function q(p) = alpha/p
% for entire simulation time
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
%   newmassadded = total mass added to layer during this step

global g;

addedpart = param.alpha./C_old.*dt;
addedpart(addedpart==Inf) = 0;
addedpart(isnan(addedpart)) = 0;

C_new = C_old + addedpart;

newmassadded = sum(sum(addedpart))*g.dx*g.dy;
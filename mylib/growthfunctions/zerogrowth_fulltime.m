function [C_new,newmassadded] = zerogrowth_fulltime(param,C_old,dt,t,massadded)
% [C_new,newmassadded] = zerogrowth_fulltime(param,C_old,dt,t,massadded)
%
% Zero growth function q(p) = 0
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
%   newmassadded = mass added to layer during this step

C_new = C_old;

newmassadded = 0;
function [C_new,newmassadded] = constant_masslimited(param,C_old,dt,t,massadded)
% [C_new,newmassadded] = constant_masslimited(param,C_old,dt,t,massadded)
%
% Constant growth function q(p) = alpha
% until the mass added over time is =(initial mass), then zero growth
% (if initial mass is m0, then max total mass at end is 2*m0, and thus the
% max amount of added mass is m0)
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

global g init_mass;

if massadded<init_mass/2
    
    C_new = C_old + param.alpha.*(C_old>0).*dt;
    
    newmassadded = sum(sum(param.alpha.*(C_old>0).*dt))*g.dx*g.dy;

else
    C_new = C_old;
    
    newmassadded = 0;
end
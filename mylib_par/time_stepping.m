function [Dt,b] = time_stepping(Phi_new,Phi_old,dt,b,g,init_cond)
% [Dt,b] = time_stepping(Phi_new,Phi_old,dt,b)
%
% Builds sparse matrix of the time step.  Adds scaling needed for nodes
% that were outside of the domain in the last step, but now are inside the
% domain
%
% inputs:
%   Phi's = level sets
%   dt    = time step
%   b     = right hand side
%
% output:
%   Dt = sparse matrix of time step

nx = g.Nx; %%% number of intervals in the x-direction
ny = g.Ny; %%% number of intervals in the x-direction

bdy = init_cond.bdy;

Dt = dt*speye((nx+1)*(ny+1));
for j = 1:ny+1
    for i = 1:nx+1
        if Phi_new(j,i)>=0 && Phi_old(j,i)<0
            Dt((nx+1)*(j-1)+i,(nx+1)*(j-1)+i) = dt*Phi_new(j,i)...
                                              /(Phi_new(j,i)-Phi_old(j,i));
            b((nx+1)*(j-1)+i) = bdy;
        end
    end
end
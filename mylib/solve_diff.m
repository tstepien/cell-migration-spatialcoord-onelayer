function C_new = solve_diff(param,lapl,C_old,Phi_old,Phi_new,dt)
% C_new = solve_diff(param,lapl,C_old,Phi_old,Phi_new,dt)
%
% Solve the coupled diffusion equation
%
% inputs:
%   param = parameters (structure with Fk,kb,rho0) - note that Fk = F/k and
%           kb = k/b due to parameter identifiability
%   lapl  = contains Lxx, Lyy
%           Laplacians for x- and y-directions
%   C_old = old solution
%   Phi's = level sets
%   dt    = time step
%
% output:
%   C_new = new solution

global g;

nx = g.Nx + 1; %%% number of nodes in the x-direction
ny = g.Ny + 1; %%% number of nodes in the y-direction

%%%----------------- build Laplacian matrices and RHS ------------------%%%
C_cut = reshape((C_old.*(Phi_new>=0))',nx*ny,1);

%%% set equal to zero nodes outside the domain
lapl_cut = laplacian_cut(lapl,Phi_new);
[Dt,C_cut] = time_stepping(Phi_new,Phi_old,dt,C_cut);

[M,b,C_cut] = laplacian_update(param,lapl_cut,Phi_new,Dt,C_cut);

z = C_cut + b;
w = M\z;

C_new = reshape(w,nx,ny)';
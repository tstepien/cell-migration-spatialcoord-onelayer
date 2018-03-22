function Phi_new = levelset_update(Phi,dt,Vx,Vy,Veta,Vzeta,Gs)
% Phi_new = levelset_update(Phi,dt,Vx,Vy,Veta,Vzeta,Gs)
%
% advection of the level set
%
% inputs:
%   Phi   = level set
%   dt    = time step
%   Vx    = velocity in the x direction
%   Vy    = velocity in the y direction
%   Veta  = velocity in the eta direction
%   Vzeta = velocity in the zeta direction
%   Gs    = gradient of level set in the x, y, eta, and zeta directions
%
% output:
%   Phi_new = updated level set

global g;

Nx = g.Nx; %%% number of intervals in the x-direction
Ny = g.Ny; %%% number of intervals in the y-direction

if isstruct(Gs)==0
    keyboard
end

Phi_new = Phi + dt*(-1/2)*(Vx.*Gs.x + Vy.*Gs.y + Veta.*Gs.eta ...
                                                         + Vzeta.*Gs.zeta);

%%% fixes the effects at the outer grid boundary
Phi_new(1,2:Nx)    = Phi_new(2,2:Nx);
Phi_new(Ny+1,2:Nx) = Phi_new(Ny,2:Nx);
Phi_new(2:Ny,1)    = Phi_new(2:Ny,2);
Phi_new(2:Ny,Nx+1) = Phi_new(2:Ny,Nx);
Phi_new(1,1)       = (Phi_new(1,2) + Phi_new(2,1))/2;
Phi_new(1,Nx+1)    = (Phi_new(1,Nx) + Phi_new(2,Nx+1))/2;
Phi_new(Ny+1,Nx+1) = (Phi_new(Ny+1,Nx) + Phi_new(Ny,Nx+1))/2;
Phi_new(Ny+1,1)    = (Phi_new(Ny+1,2) + Phi_new(Ny,1))/2;
function Phi_e = levelset_extension(Phi)
% Phi_e = levelset_extension(Phi)
%
% extends level set
%
% input:
%   Phi = level set
%
% output:
%   Phi_e = extended level set

global g;

nx = g.Nx+1; %%% number of nodes in the x-direction
ny = g.Ny+1; %%% number of nodes in the y-direction

Phi_e = zeros(ny+6,nx+6);

Phi_e(4:ny+3,4:nx+3) = Phi(1:ny,1:nx);

Phi_e(4:ny+3,[1:3 nx+(4:6)]) = Phi_e(4:ny+3,[7:-1:5 nx+(2:-1:0)]);

Phi_e([3:-1:1 ny+(4:6)],1:nx+6) = Phi_e([5:7 ny+(2:-1:0)],1:nx+6);
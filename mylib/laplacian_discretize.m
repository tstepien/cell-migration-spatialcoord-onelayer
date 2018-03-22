function [Lxx,Lyy] = laplacian_discretize(param,bc)
% [Lxx,Lyy] = laplacian_discretize(param,bc)
%
% A matrix representing the Laplace operator in Omega using second order
% centered differences (second order accurate due to use of ghost points)
%
% inputs:
%   param = parameters (structure with Fk,kb,rho0) - note that Fk = F/k and
%           kb = k/b due to parameter identifiability
%   bc    = this is a string name listing the boundary conditions desired
%           for the boundary of the entire domain
%           ->'neumannbc' (no flux) if boundary is edge of coverslip region
%           ->'dirichletbc' (constant source of cells beyond boundary) if
%              boundary is edge of observable region
%
% outputs:
%   Lxx = Laplacian for x-direction
%   Lyy = Laplacian for y-direction

global g;

if nargin<2
    bc = 'neumannbc';
end

D = param.kb;

dx = g.dx; %%% grid spacing in the x-direction
dy = g.dy; %%% grid spacing in the y-direction

NTOT = (g.Nx+1)*(g.Ny+1); %%% number of total nodes
NX = g.Nx+1;              %%% number of total nodes in x-direction
NY = g.Ny+1;              %%% number of total nodes in y-direction

if strcmp(bc,'dirichletbc')==1
    Lxx = 1/dx^2 * spdiags([repmat([D*ones(NX-2,1) ; 0 ; 0],NY,1) ,...
        repmat([0 ; -2*D*ones(NX-2,1) ; 0],NY,1) ,...
        repmat([0 ; 0 ; D*ones(NX-2,1)],NY,1)],-1:1,NTOT,NTOT);
elseif strcmp(bc,'neumannbc')==1
    Lxx = 1/dx^2 * spdiags([repmat([D*ones(NX-2,1) ; 2*D ; 0],NY,1) ,...
        repmat([-2*D ; -2*D*ones(NX-2,1) ; -2*D],NY,1) ,...
        repmat([0 ; 2*D ; D*ones(NX-2,1)],NY,1)],-1:1,NTOT,NTOT);
end

if strcmp(bc,'dirichletbc')==1
    Lyy = 1/dy^2 * spdiags([...
        [repmat(D*ones(NX,1),NY-2,1) ; zeros(2*NX,1)] ,...
        [zeros(NX,1) ; repmat(-2*D*ones(NX,1),NY-2,1) ; zeros(NX,1)] ,...
        [zeros(2*NX,1) ; repmat(D*ones(NX,1),NY-2,1)] ],...
        [-NX,0,NX],NTOT,NTOT);
elseif strcmp(bc,'neumannbc')==1
    Lyy = 1/dy^2 * spdiags([...
        [repmat(D*ones(NX,1),NY-2,1) ; 2*D*ones(NX,1) ; zeros(NX,1)] , ...
        [-2*D*ones(NX,1) ; repmat(-2*D*ones(NX,1),NY-2,1) ; ...
        -2*D*ones(NX,1)] ,...
        [zeros(NX,1) ; 2*D*ones(NX,1) ; repmat(D*ones(NX,1),NY-2,1)] ],...
        [-NX,0,NX],NTOT,NTOT);
end
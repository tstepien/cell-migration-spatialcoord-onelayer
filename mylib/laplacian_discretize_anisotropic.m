function [Lxx,Lyy] = laplacian_discretize_anisotropic(D,bc)
% lapl = laplacian_discretize_anisotropic(D,bc)
%
% A matrix representing the Laplace operator in Omega using second order
% centered differences (second order accurate due to use of ghost points)
% allowing for nonuniform anisotropic diffusion
%
% inputs:
%   D  = diffusion matrices (structure with x- and y- directions)
%   bc = this is a string name listing the boundary conditions desired
%        for the boundary of the entire domain
%           ->'neumannbc' (no flux) if boundary is edge of coverslip region
%           ->'dirichletbc' (constant source of cells beyond boundary) if
%              boundary is edge of observable region
%
% outputs:
%   lapl = structure of Laplacians for x- and y- directions {Lxx,Lyy}

global g;

if nargin<2
    bc = 'neumannbc';
end

dx = g.dx; %%% grid spacing in the x-direction
dy = g.dy; %%% grid spacing in the y-direction

NTOT = (g.Nx+1)*(g.Ny+1); %%% number of total nodes
NX = g.Nx+1;              %%% number of total nodes in x-direction
NY = g.Ny+1;              %%% number of total nodes in y-direction

Dx = reshape(D.x',NX*NY,1);
Dy = reshape(D.y',NX*NY,1);

LAPxx = zeros(NTOT,NTOT); %%% pre-allocate
for j = 1:NY
    for i = 1 %%% left
        dxR = (Dx(NX*(j-1)+i) + Dx(NX*(j-1)+i+1))/2;
        if strcmp(bc,'neumannbc')==1 %%% Neumann BCs
            LAPxx(NX*(j-1)+i,NX*(j-1)+i) = -2*dxR;
            LAPxx(NX*(j-1)+i,NX*(j-1)+i+1) = 2*dxR;
        elseif strcmp(bc,'dirichletbc')==1 %%% Dirichlet BCs
            LAPxx(NX*(j-1)+i,NX*(j-1)+i) = 0;
            LAPxx(NX*(j-1)+i,NX*(j-1)+i+1) = 0;
        end
    end
    for i = 2:NX-1
        dxL = (Dx(NX*(j-1)+i-1) + Dx(NX*(j-1)+i))/2;
        dxR = (Dx(NX*(j-1)+i+1) + Dx(NX*(j-1)+i))/2;
        LAPxx(NX*(j-1)+i,(NX*(j-1)+i-1)) = dxL;
        LAPxx(NX*(j-1)+i,(NX*(j-1)+i)) = -(dxL+dxR);
        LAPxx(NX*(j-1)+i,(NX*(j-1)+i+1)) = dxR;
    end
    for i = NX %%% right
        dxL = (Dx(NX*(j-1)+i-1) + Dx(NX*(j-1)+i))/2;
        if strcmp(bc,'neumannbc')==1 %%% Neumann BCs
            LAPxx(NX*(j-1)+i,NX*(j-1)+i-1) = 2*dxL;
            LAPxx(NX*(j-1)+i,NX*(j-1)+i) = -2*dxL;
        elseif strcmp(bc,'dirichletbc')==1 %%% Dirichlet BCs
            LAPxx(NX*(j-1)+i,NX*(j-1)+i-1) = 0;
            LAPxx(NX*(j-1)+i,NX*(j-1)+i) = 0;
        end
    end
end

LAPyy = zeros(NTOT,NTOT); %%% pre-allocate
for i = 1:NX
    for j = 1 %%% bottom
        dyR = (Dy(NX*(j-1)+i) + Dy(NX*j+i))/2;
        if strcmp(bc,'neumannbc')==1 %%% Neumann BCs
            LAPyy(NX*(j-1)+i,NX*(j-1)+i) = -2*dyR;
            LAPyy(NX*(j-1)+i,NX*(j-0)+i) = 2*dyR;
        elseif strcmp(bc,'dirichletbc')==1 %%% Dirichlet BCs
            LAPyy(NX*(j-1)+i,NX*(j-1)+i) = 0;
            LAPyy(NX*(j-1)+i,NX*(j-0)+i) = 0;
        end
    end
    for j = 2:NY-1
        dyL = (Dy(NX*(j-2)+i) + Dy(NX*(j-1)+i))/2;
        dyR = (Dy(NX*(j-1)+i) + Dy(NX*j+i))/2;
        LAPyy(NX*(j-1)+i,NX*(j-0)+i) = dyR;
        LAPyy(NX*(j-1)+i,NX*(j-1)+i) = -(dyL+dyR);
        LAPyy(NX*(j-1)+i,NX*(j-2)+i) = dyL;
    end
    for j = NY %%% top
        dyL = (Dy(NX*(j-2)+i) + Dy(NX*(j-1)+i))/2;
        if strcmp(bc,'neumannbc')==1 %%% Neumann BCs
            LAPyy(NX*(j-1)+i,NX*(j-2)+i) = 2*dyL;
            LAPyy(NX*(j-1)+i,NX*(j-1)+i) = -2*dyL;
        elseif strcmp(bc,'dirichletbc')==1 %%% Dirichlet BCs
            LAPyy(NX*(j-1)+i,NX*(j-2)+i) = 0;
            LAPyy(NX*(j-1)+i,NX*(j-1)+i) = 0;
        end
    end
end

Lxx = sparse(1/dx^2 * LAPxx);
Lyy = sparse(1/dy^2 * LAPyy);
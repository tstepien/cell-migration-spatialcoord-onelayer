function lapl_cut = laplacian_cut(lapl,Phi)
% lapl_cut = cut_laplacian(lapl,Phi)
%
% A matrix representing the Laplace operator based on the level set.  It is
% updated from the original Laplace operator by setting (cutting) those
% points at which the cell colony is not located equal to zero.
%
% inputs:
%   lapl = structure of Laplacians {Lxx,Lyy}
%   Phi  = level set
%
% outputs:
%   lapl_cut = structure of updated Laplacians using cut-cell method

global g;

nx = g.Nx + 1; %%% number of nodes in the x-direction
ny = g.Ny + 1; %%% number of nodes in the y-direction

M = sign(Phi') + 1/2;
M = M(:);
M = spdiags(M,0,nx*ny,nx*ny);

lapl_cut.Lxx = max(sign(M),0)*lapl.Lxx;
lapl_cut.Lyy = max(sign(M),0)*lapl.Lyy;
function kappa = curvature2D(Phi)
% kappa = curvature2D(Phi)
%
% Computes the curvature kappa = |x'y'' - y'x''| / ((x')^2 + (y')^2)^(3/2)
% from the level set in a small band around the edge of the cell layer
%
% Input:
%   Phi = level set
%
% Output:
%   kappa = curvature

global g;

dx = g.dx;
dy = g.dy;

eps = 1e-10;

[px,py] = gradient( Phi , dx , dy );
[pxx,pxy] = gradient( px , dx , dy );
[~,pyy] = gradient( py , dx , dy );

kappa = ( py.^2.*pxx - 2*px.*py.*pxy + px.^2.*pyy ) ...
    ./ (sqrt( px.^2 + py.^2 + eps ).^3);

band = abs(Phi)<max(dx,dy);

kappa = kappa.*band;
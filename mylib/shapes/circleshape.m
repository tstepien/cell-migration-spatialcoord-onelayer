function Phi0 = circleshape(radius)
% Phi0 = circleshape(radius)
%
% Specifies the initial cell boundary geometry as a circle.
% Computes the distance from all the mesh points to the initial cell colony
% boundary.  This distance is the signed distance function Phi.
% For the points inside the cell colony, Phi0 returns a positive value.
% For the points outside the cell colony, Phi0 returns a negative value.
%
% input:
%   radius = radius of the circle
%
% output:
%   Phi0 = initial level set

global g;

Phi0 = radius - sqrt(g.Xnew.^2 + g.Ynew.^2);
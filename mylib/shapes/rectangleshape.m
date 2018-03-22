function Phi0 = rectangleshape(rectarea)
% Phi0 = rectangleshape(rectarea)
%
% Specifies the initial cell boundary geometry as a rectangle.
% Computes the distance from all the mesh points to the initial cell colony
% boundary.  This distance is the signed distance function Phi.
% For the points inside the cell colony, Phi0 returns a positive value.
% For the points outside the cell colony, Phi0 returns a negative value.
%
% input:
%   rectarea = area of the rectangle
%
% output:
%   Phi0 = initial level set

global g;

Phi0 = rectarea - max(abs(g.Xnew),abs(g.Ynew));
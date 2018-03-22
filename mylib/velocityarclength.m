function [vnormal,arclengths] = velocityarclength(Phi_new,comp_curve,Vx,Vy)
% [vnormal,arclengths] = velocityarclength(Phi_new,comp_curve,Vx,Vy)
%
% inputs:
%   Phi_new    = level set
%   comp_curve = contour curve
%   Vx         = velocity in x-direction
%   Vy         = velocity in y-direction
%
% outputs:
%   vnormal    = velocity of migration at each point along curve
%   arclengths = arc lengths between each consecutive pair of contour
%                points

global g;

[rows,cols] = size(comp_curve);
if rows>cols
    comp_curve = comp_curve';
end

[nx,ny] = gradient(Phi_new,g.dx,g.dy);

vcx = interp2(g.x,g.y,Vx,comp_curve(1,:),comp_curve(2,:),'linear');
vcy = interp2(g.x,g.y,Vy,comp_curve(1,:),comp_curve(2,:),'linear');
ncx = interp2(g.x,g.y,nx,comp_curve(1,:),comp_curve(2,:),'linear');
ncy = interp2(g.x,g.y,ny,comp_curve(1,:),comp_curve(2,:),'linear');

%%% normalize
ncx = -ncx./sqrt(ncx.^2 + ncy.^2);
ncy = -ncy./sqrt(ncx.^2 + ncy.^2);

%%% v dot n; velocity of migration at each point along curve
vnormal = vcx.*ncx + vcy.*ncy;

%%% take contour points - find arc lengths between each consecutive pair
arclengths = sqrt(diff(comp_curve(1,:)).^2 + diff(comp_curve(2,:)).^2);
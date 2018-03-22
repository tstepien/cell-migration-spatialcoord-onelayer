function d = find_dist(pt_x,pt_y,line_x,line_y)
% d = find_dist(pt_x,pt_y,line_x,line_y)
%
% computes distance between a mesh point and all points on a line segment 
% between two consecutive boundary points
%
% OR (?)
%
% finds distance from every experimental point to each line segment of the
% model prediction            
%
% inputs:
%   pt_x   = x-components of mesh point
%   pt_y   = y-components of mesh point
%   line_x = x-components of the two points composing the line segment
%   line_y = y-components of the two points composing the line segment
%
% output:
%   d = distance

a = sqrt((pt_x - line_x(1)).^2 + (pt_y - line_y(1)).^2);
b = sqrt((pt_x - line_x(2)).^2 + (pt_y - line_y(2)).^2);
c = sqrt((line_x(2) - line_x(1))^2 + (line_y(2) - line_y(1))^2);

lineind = abs(a.^2 - b.^2) < c^2;

%%% calculate the area of the triangle using Heron's formula (s is the 
%%% semiperimeter=half of the triangle's perimeter)
s = (a+b+c)/2;
triarea = sqrt(s.*(s-a).*(s-b).*(s-c) + 1e-8);

%%% find length of the perpendicular line from the mesh point to the line
%%% segment using triarea=(1/2)*base*height where base=c
h = 2*triarea/c;

%%% calculate the distance from the mesh point to all points on the line
%%% segment
d = h.*lineind + min(a,b).*(1-lineind);
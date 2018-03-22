function d = find_dist_onepoint_onefullcurve(pt_x,pt_y,curve)
% d = find_dist_onepoint_onefullcurve(pt_x,pt_y,curve)
%
% computes distance between one point and each line segment of curve
%
% inputs:
%   pt_x  = x-component of point
%   pt_y  = y-component of point
%   curve = coordinates of curve that will be compared to
%       (x coordinate in the 1st column and y coordinate in 2nd)
%
% output:
%   d = distance (vector that has same length as curve)

curveX = curve(:,1);
curveY = curve(:,2);

CC = length(curve);

a = sqrt((pt_x - curveX(1:CC-1)).^2 + (pt_y - curveY(1:CC-1)).^2);
b = sqrt((pt_x - curveX(2:CC)).^2 + (pt_y - curveY(2:CC)).^2);
c = sqrt((curveX(2:CC) - curveX(1:CC-1)).^2 + (curveY(1:CC-1) - curveY(2:CC)).^2);

lineind = abs(a.^2 - b.^2) < c.^2;

%%% calculate the area of the triangle using Heron's formula (s is the
%%% semiperimeter=half of the triangle's perimeter)
s = (a+b+c)/2;
triarea = sqrt(s.*(s-a).*(s-b).*(s-c) + 1e-8);

%%% find length of the perpendicular line from the mesh point to the line
%%% segment using triarea=(1/2)*base*height where base=c
h = 2*triarea./c;

%%% calculate the distance from the mesh point to all points on the line
%%% segment
d = h.*lineind + min(a,b).*(1-lineind);
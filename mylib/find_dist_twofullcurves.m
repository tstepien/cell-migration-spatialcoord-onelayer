function d = find_dist_twofullcurves(curve1,curve2)
% d = find_dist_twofullcurves(curve1,curve2)
%
% computes distance between all points in curve1 compared to each line
% segment of curve2
%
% inputs:
%   curve1 = coordinates of curve in question
%   curve2 = coordinates of curve that will be compared to
%       (for both - x coordinate in the 1st column and y coordinate in 2nd)
%
% output:
%   d = distance (vector that has same length as curve1)

xpts = curve1(:,1);
ypts = curve1(:,2);

L1 = length(curve1);

d = zeros(L1,1);

for i = 1:L1
    distances = find_dist_onepoint_onefullcurve(xpts(i),ypts(i),curve2);
    d(i) = min(abs(distances));
end
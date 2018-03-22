function Phi0 = experimentalshape(file_bdy,file_mask,exp_scale)
% Phi0 = experimentalshape(file_bdy,file_mask,exp_scale)
%
% Specifies the initial cell boundary geometry from inputted experimental
% data using a .tif file.
%
% Computes the distance from all the mesh points to the initial cell colony
% boundary.  This distance is the signed distance function Phi.
% For the points inside the cell colony, Phi0 returns a positive value.
% For the points outside the cell colony, Phi0 returns a negative value.
%
% input:
%   file_bdy  = script name of txt file that contains data points of
%               experimental boundary
%   file_mask = script name of tif file that defines where cells are (1)
%               and where cells are not (-1)
%   exp_scale = pixels per micron scale
%
% output:
%   Phi0 = initial level set

global g;

coord = dlmread(file_bdy);
% 1st column of coord corresponds to x
% 2nd column of coord corresponds to y
% scale and translate from pixels to microns
newCoord = [coord(:,1)/exp_scale + g.xmin , coord(:,2)/exp_scale + g.ymin];

mask = double(imread(file_mask,'tif'));
xmask = linspace(g.xmin,g.xmax,size(mask,2));
ymask = linspace(g.ymin,g.ymax,size(mask,1));
[xMask,yMask] = meshgrid(xmask,ymask);
interpol = interp2(xMask,yMask,mask,g.Xnew,g.Ynew)>0;
newMask = interpol + (interpol-1);

Phi0 = zeros(g.Nx+1,g.Ny+1);
for i = 1:g.Nx+1 % x: columns
    for j = 1:g.Ny+1 % y: rows
        Phi0(j,i) = min(sqrt((g.x(i) - newCoord(:,1)).^2 ...
            + (g.y(j) - newCoord(:,2)).^2));
    end
end

% elementwise multiply by the new mask so that outside of the colony, 
% distances are negative, while inside the colony, distances are positive
Phi0 = Phi0.*newMask;
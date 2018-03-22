function g = mesh_generation(number_nodes,exp_px,exp_scale)
% g = mesh_generation(number_nodes,xmicrons,ymicrons)
%
% This function generates the mesh.
%
% inputs:
%   number_nodes = number of nodes in the discretization
%   exp_px       = [x size,y size] = size of experimental window in pixels
%   exp_scale    = pixels per micron scale
%
% output
%   g = structure with information on the mesh

g.xmicrons = exp_px(1)/exp_scale; %%% outer dimensions of the experimental
g.ymicrons = exp_px(2)/exp_scale; %%% region in microns

g.xmin = -g.xmicrons/2; %%% bounds of rectangular grid centered at origin
g.xmax = g.xmicrons/2;

g.ymin = -g.ymicrons/2;
g.ymax = g.ymicrons/2;

g.Nx = number_nodes-1; %%% number of intervals in the x-direction
g.Ny = number_nodes-1; %%% number of intervals in the y-direction

g.dx = (g.xmax-g.xmin)/g.Nx; %%% grid spacing in the x-direction
g.dy = (g.ymax-g.ymin)/g.Ny; %%% grid spacing in the y-direction

g.x = (g.xmin:g.dx:g.xmax)';
g.y = (g.ymin:g.dy:g.ymax)';

[g.Xnew,g.Ynew] = meshgrid(g.x,g.y);
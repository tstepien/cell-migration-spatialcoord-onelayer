function densratios = prep_expdata_dens(exp_densratios,g)
% densratios = prep_expdata_dens(exp_densratios)
%
% convert the experimental data (density ratios only) from pixels to microns
%
% input:
%   exp_densratios = file name of experimental density ratio det F data
%
% output:
%   densratios = experimental density ratios fit to numerical grid

load(exp_densratios)

[rows,cols] = size(exp_densratios{1});
xexp = linspace(g.xmin,g.xmax,cols);
yexp = linspace(g.ymin,g.ymax,rows);
[xExp,yExp] = meshgrid(xexp,yexp);
L = length(exp_densratios);

densratios = cell(1,L);

for i = 1:L
    exp_densratios{i} = full(exp_densratios{i});
    densratios{i} = interp2(xExp,yExp,exp_densratios{i},g.Xnew,g.Ynew);
end
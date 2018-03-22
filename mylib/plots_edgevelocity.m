function plots_edgevelocity(measured_times,velocity)
% plots_edgevelocity(measured_times,velocity)
%
% This produces the edge velocity figure.
%
% inputs:
%   measured_times = times at which the velocity is calculated
%   velocity's = average instantaneous normal velocity at the cell layer 
%                edge

figure(4)
plot(measured_times,velocity,'r')
xlabel('\bf time (h)','FontSize',20,'Interpreter','latex')
ylabel({'\bf average instantaneous normal',...
    '\bf velocity of the edge ($\mu$m/h)'},'FontSize',14,...
    'Interpreter','latex')
set(gca,'FontName','Times','FontSize',16,'Units','normalized',...
    'Position',[0.15 0.15 0.75 0.75]); %axes
set(gcf,'Units', 'centimeters','Position',[10 10 17 13],...
    'PaperPositionMode','auto');
box on
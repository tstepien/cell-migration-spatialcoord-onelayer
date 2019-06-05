L = 24;

recoverdensity = cell(1,L);

recoverdensity{1} = density{1};

for i = 2:L
    recoverdensity{i} = 1./exp_densratio{1+5*(i-2)}.*recoverdensity{i-1};
    recoverdensity{i}(isnan(recoverdensity{i})) = 0;
    
%     recoverdensity{i}(recoverdensity{i}>10^4) = 0;
end






%%%--------------------------- density plots ---------------------------%%%
color = 'r';

mid = 51;%ceil(length(g.y)/2);

figure(5)
hold on
for j = 1:L
    plot(g.x,recoverdensity{j}(mid,:));
end
hold off

% set(gca,'YLim',[0,10000])

xlabel('radial position ($\mu$m)','FontSize',20,'Interpreter','latex')
ylabel('density (cells/mm$^2$)','FontSize',20,'Interpreter','latex')
set(gca,'FontName','Times','FontSize',16,'Units','normalized',...
    'Position',[0.2 0.2 0.75 0.75]); %axes
set(gcf,'Units', 'centimeters','Position',[1 1 15 15],...
    'PaperPositionMode','auto');
box on
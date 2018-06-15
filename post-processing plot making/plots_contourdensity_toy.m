global g init_cond;

bdy = init_cond.bdy;
% color = 'r';
color = [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330];

%%%--------------------------- contour plot ----------------------------%%%
figure
hold on
for i=1:length(g.x)
   plot([g.x(i) g.x(i)],[g.y(1) g.y(end)],':','Color',[0.5 0.5 0.5]) %y grid lines
   hold on    
end
for i=1:length(g.y)
   plot([g.x(1) g.x(end)],[g.y(i) g.y(i)],':','Color',[0.5 0.5 0.5]) %x grid lines
   hold on    
end

for i=1:length(Phi)
    if i==1
        contour(g.x,g.y,Phi{i},[0 0],'Color',color(i,:),'LineWidth',3)
    else
        contour(g.x,g.y,Phi{i},[0 0],'Color',color(i,:),'LineWidth',1.5)
    end
end
hold off
axis([g.xmin g.xmax g.ymin g.ymax])
set(gca,'FontName','Times','FontSize',18,'Units','normalized',...
    'Position',[0.17 0.13 0.82 0.82]); %axes
set(gcf,'Units', 'centimeters','Position',[2 15 15 15],...
    'PaperPositionMode','auto');
box on
xlabel('$\mu$m','FontSize',20,'Interpreter','latex')
ylabel('$\mu$m','FontSize',20,'Interpreter','latex')



%%--------------------------- density plots ---------------------------%%%
if length(g.y)==100
    mid = 51;
else
    mid = ceil(length(g.y)/2);
end
pos = [];
dens = [];
xall = cell(size(Phi));
Call = cell(size(Phi));
for j=1:length(Phi)
    for i = 1:length(g.x)-1
        if Phi{j}(mid,i)<0 && Phi{j}(mid,i+1)>0
            pos = [pos , g.x(i+1) - Phi{j}(mid,i+1)/(Phi{j}(mid,i+1)-Phi{j}(mid,i))*g.dx];
            dens = [dens , bdy];
        elseif Phi{j}(mid,i)>0 && Phi{j}(mid,i+1)>0
            pos = [pos , g.x(i)];
            dens = [dens , density{j}(mid,i)];
        elseif Phi{j}(mid,i)>0 && Phi{j}(mid,i+1)<0
            pos = [pos , g.x(i) + -Phi{j}(mid,i)/(Phi{j}(mid,i+1)-Phi{j}(mid,i))*g.dx];
            dens = [dens , bdy];
        end
    end
    xall{j} = pos;
    Call{j} = dens;
    pos = [];
    dens = [];
end

figure
hold on
for i=1:length(g.x)
   plot([g.x(i) g.x(i)],[1000 5000],':','Color',[0.5 0.5 0.5]) % grid lines
   hold on    
end

for i=1:length(Phi)
    if i==1
        plot(xall{i},Call{i},'Color',color(i,:),'LineWidth',3)
    else
        plot(xall{i},Call{i},'Color',color(i,:),'LineWidth',1.5)
    end
end
hold off

axis([g.xmin g.xmax 1000 5000])
set(gca,'FontName','Times','FontSize',18,'Units','normalized',...
    'Position',[0.17 0.13 0.82 0.82]); %axes
set(gcf,'Units', 'centimeters','Position',[1 1 15 15],...
    'PaperPositionMode','auto');
box on
xlabel('radial position ($\mu$m)','FontSize',20,'Interpreter','latex')
ylabel('density (cells/mm$^2$)','FontSize',20,'Interpreter','latex')
function plots_contourdensity(Phi_new,C_soln,firsttime)
% plots_contourdensity(Phi_new,C_soln,firsttime)
%
% This produces the density profile figures.
%
% inputs:
%   Phi_new   = level set
%   C_soln    = C_old on first time invoking the function,
%               C_new on the other times invoking the function
%   firsttime = optional argument, draw darker lines first time around if
%               firsttime='first'

global g init_cond;

if nargin<3
    firsttime=[];
end

bdy = init_cond.bdy;
color = 'r';

%%%--------------------------- contour plot ----------------------------%%%
figure(1)
if strcmp(firsttime,'first')==1
    contour(g.x,g.y,Phi_new,[0 0],'Color',color,'LineWidth',3)
else
    contour(g.x,g.y,Phi_new,[0 0],'Color',color)
end
hold on
drawnow
if strcmp(firsttime,'first')==1
    xlabel('\bf $\mu$m','FontSize',20,'Interpreter','latex')
    ylabel('\bf $\mu$m','FontSize',20,'Interpreter','latex')
    axis([g.xmin g.xmax g.ymin g.ymax])
    set(gca,'Ydir','reverse',... %change to image coordinates origin
        'FontName','Times','FontSize',16,'Units','normalized',...
        'Position',[0.2 0.2 0.75 0.75]); %axes
    set(gcf,'Units', 'centimeters','Position',[2 15 15 15],...
        'PaperPositionMode','auto');
    box on
end



%%%--------------------------- density plots ---------------------------%%%
mid = 51;%ceil(length(g.y)/2);
pos = [];
dens = [];
for i = 1:length(g.x)-1
    if Phi_new(mid,i)<0 && Phi_new(mid,i+1)>0
        pos = [pos , g.x(i+1) - Phi_new(mid,i+1)/(Phi_new(mid,i+1)-Phi_new(mid,i))*g.dx];
        dens = [dens , bdy];
    elseif Phi_new(mid,i)>0 && Phi_new(mid,i+1)>0
        pos = [pos , g.x(i)];
        dens = [dens , C_soln(mid,i)];
    elseif Phi_new(mid,i)>0 && Phi_new(mid,i+1)<0
        pos = [pos , g.x(i) + -Phi_new(mid,i)/(Phi_new(mid,i+1)-Phi_new(mid,i))*g.dx];
        dens = [dens , bdy];
    end
end
xall = pos;
Call = dens;

figure(2)
if strcmp(firsttime,'first')==1
    plot(xall,Call,'Color',color,'LineWidth',3)
else
    plot(xall,Call,'Color',color)
end
hold on
drawnow
if strcmp(firsttime,'first')==1
    xlabel('radial position ($\mu$m)','FontSize',20,'Interpreter','latex')
    ylabel('density (cells/mm$^2$)','FontSize',20,'Interpreter','latex')
    set(gca,'FontName','Times','FontSize',16,'Units','normalized',...
        'Position',[0.2 0.2 0.75 0.75]); %axes
    set(gcf,'Units', 'centimeters','Position',[1 1 15 15],...
        'PaperPositionMode','auto');
    box on
end
    
% figure(3)
% plot(xprofile,Cprofile,'Color',color)
% hold on
% drawnow
% if strcmp(firsttime,'first')==1
%     xlabel('radial position ($\mu$m)','Interpreter','latex')
%     ylabel('density profiles translated (one half) (cells/mm^2)')
%     set(gca,'FontName','Times','FontSize',16,'Units','normalized',...
%         'Position',[0.2 0.2 0.75 0.75]); %axes
%     set(gcf,'Units', 'centimeters','Position',[20 1 15 15],...
%         'PaperPositionMode','auto');
%     box on
% end
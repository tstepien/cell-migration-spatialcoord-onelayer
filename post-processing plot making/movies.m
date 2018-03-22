%%% MUST USE LINUX - Mac version of Matlab too old (movie gets skewed when
%%% saving)

clc

nFrames = length(plot_times);
mov(1:nFrames) = struct('cdata',[],'colormap',[]);

bdy = param.rho0*exp(-param.Fk);

for j = 1:10:nFrames
    cla
    set(gca,'nextplot','replacechildren');
    
    subplot(1,2,1)
    hold on
    if j == 1
        % plot thickened 1st stuff (dark)
        contour(g.x,g.y,Phi_init,[0 0],'Color','r','LineWidth',3);
    elseif j==2
        % plot thickened 1st stuff (light)
        contour(g.x,g.y,Phi_init,[0 0],'Color',[1 .75 .75],'LineWidth',3);
        
        % plot 2nd stuff (dark)
        contour(g.x,g.y,Phi{1,j},[0 0],'Color','r');
    else
        % plot thickened 1st stuff (light)
        contour(g.x,g.y,Phi_init,[0 0],'Color',[1 .75 .75],'LineWidth',3);
        for i = 2:j-1
            % plot 2nd-(j-1)th stuff (light)
            contour(g.x,g.y,Phi{1,i},[0 0],'Color',[1 .75 .75]);
        end
        
        % plot jth stuff (dark)
        contour(g.x,g.y,Phi{1,j},[0 0],'Color','r');
    end
    title(['hour: ',num2str(plot_times(j))],'FontSize',16,'Interpreter',...
        'latex','Units','normalized','Position', [1.2 1.07])
    
    xlabel('\bf $\mu$m','FontSize',16,'Interpreter','latex')
    ylabel('\bf $\mu$m','FontSize',16,'Interpreter','latex')
    box on
    set(gca,'FontName','Times','FontSize',16,'Units','normalized',...
        'Position',[0.1 0.15 0.35 0.75]); %axes
    
    subplot(1,2,2)
    hold on
    if j == 1
        % plot 1st stuff (dark)
        [pos1,dens1] = movies_density(g,Phi_init,density{j},bdy);
        plot(pos1,dens1,'Color','r','LineWidth',3)
        
    elseif j==2
        % plot 1st stuff (light)
        [pos1,dens1] = movies_density(g,Phi_init,density{1},bdy);
        plot(pos1,dens1,'Color',[1 .75 .75],'LineWidth',3)
        
        % plot 2nd stuff (dark)
        [pos1,dens1] = movies_density(g,Phi{1,j},density{j},bdy);
        plot(pos1,dens1,'Color','r')
    else
        % plot 1st stuff (light)
        [pos1,dens1] = movies_density(g,Phi_init,density{1},bdy);
        plot(pos1,dens1,'Color',[1 .75 .75],'LineWidth',3)
        for i = 2:j-1
            % plot 2nd-(j-1)th stuff (light)
            [pos1,dens1] = movies_density(g,Phi{1,i},density{i},bdy);
            plot(pos1,dens1,'Color',[1 .75 .75])
        end
        
        % plot jth stuff (dark)
        [pos1,dens1] = movies_density(g,Phi{1,j},density{j},bdy);
        plot(pos1,dens1,'Color','r')
    end
    xlabel('radial position ($\mu$m)','FontSize',16,'Interpreter','latex')
    ylabel('density (cells/mm$^2$)','FontSize',16,'Interpreter','latex')
    box on
    set(gca,'FontName','Times','FontSize',16,'Units','normalized',...
        'Position',[0.62 0.15 0.35 0.75]); %axes

    set(gcf,'Units', 'centimeters','Position',[5 20 23 11],...
        'PaperPositionMode','auto','Color',[1 1 1]);
    axis([g.xmin g.xmax 0 max(max(density{1}))])

    pause
    
    mov(j) = getframe(gcf);
end
% movie2avi(mov,'supahcool.avi','compression','None','fps',2)
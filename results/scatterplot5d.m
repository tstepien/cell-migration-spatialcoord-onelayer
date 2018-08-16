clear variables;
clc;
close all;

load(strcat('emceeinit_10000samples_','Pos6exp3','.mat'))

numpts_alpha = 5;
numpts_rho0 = 5;

intervals_alpha = linspace(0,1,numpts_alpha);
intervals_rho0 = linspace(1000,2000,numpts_rho0);

paramsets = cell(numpts_alpha-1,numpts_rho0-1);
colors = cell(numpts_alpha-1,numpts_rho0-1);

for i=1:numpts_alpha-1
    if i==numpts_alpha-1
        ind_alpha = find(models(3,:)>=intervals_alpha(i) ...
            & models(3,:)<=intervals_alpha(i+1));
    else
        ind_alpha = find(models(3,:)>=intervals_alpha(i) ...
            & models(3,:)<intervals_alpha(i+1));
    end
    
    for j=1:numpts_rho0-1
        if j==numpts_rho0-1
            ind_rho0 = find(models(4,:)>=intervals_rho0(j) ...
                & models(4,:)<=intervals_rho0(j+1));
        else
            ind_rho0 = find(models(4,:)>=intervals_rho0(j) ...
                & models(4,:)<intervals_rho0(j+1));
        end
        
        ind_both = intersect(ind_alpha,ind_rho0);
        
        paramsets{i,j} = models(1:2,ind_both);
        colors{i,j} = minquant(ind_both);
    end
end

fstitle = 16;
fsticks = 14;

figure
for i=1:numpts_alpha-1
    for j=1:numpts_rho0-1
        subaxis(numpts_alpha-1,numpts_rho0-1,j,i,'Spacing',0.025,...
            'MarginBottom',0.06,'MarginTop',0.04,'MarginRight',0.07)
        scatter(paramsets{i,j}(1,:),paramsets{i,j}(2,:),[],colors{i,j},...
            'filled','MarkerEdgeColor',[0.6,0.6,0.6],'LineWidth',0.005)
        
        set(gca,'XLim',[0,1.5],'YLim',[500,5000],'FontSize',fsticks)
        box on
        
        if i<numpts_alpha-1
            set(gca,'XTick',[])
        elseif i==numpts_alpha-1
            xlabel('$F/k$','Interpreter','latex','FontSize',fstitle)
        end
        if j>1
            set(gca,'YTick',[])
        end
        
        if i==numpts_alpha-1 && j==numpts_rho0-1
            h = colorbar;
            set(h, 'Position', [0.93583 0.06 0.0184167 0.20643]);
        end
        
        if i==1
            if j==numpts_rho0-1
                title(strcat(['\textbf{',num2str(intervals_rho0(j)),'}'],...
                    '{\boldmath $\leq \rho_{\mathrm{unstressed}} \leq$}',...
                    ['\textbf{',num2str(intervals_rho0(j+1)),'}']),...
                    'Interpreter','latex','FontSize',fstitle)
            else
                title(strcat(['\textbf{',num2str(intervals_rho0(j)),'}'],...
                    '{\boldmath $\leq \rho_{\mathrm{unstressed}} <$}',...
                    ['\textbf{',num2str(intervals_rho0(j+1)),'}']),...
                    'Interpreter','latex','FontSize',fstitle)
            end
        end
        
        if j==1
            if i==numpts_alpha-1
                line1 = strcat(['\textbf{',num2str(intervals_alpha(i)),'}'],...
                    '{\boldmath $\leq \alpha \leq$}',...
                    ['\textbf{',num2str(intervals_alpha(i+1)),'}']);
            else
                line1 = strcat(['\textbf{',num2str(intervals_alpha(i)),'}'],...
                    '{\boldmath $\leq \alpha <$}',...
                    ['\textbf{',num2str(intervals_alpha(i+1)),'}']);
            end
            line2 = '$k/b$';
            ylabel(sprintf('\\begin{tabular}{c} %s %s %s \\end{tabular}',...
                line1,'\\',line2),'Interpreter','latex')
        end
    end
end

set(gcf,'Position',[100 300 180*numpts_rho0 140*numpts_alpha],'PaperPositionMode','auto');
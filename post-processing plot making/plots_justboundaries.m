addpath ../mylib

global g;

%%% grayscale conversion (luminance): 0.299r + 0.587g + 0.114b
gsc = [0.299 0.587 0.114];

imagetype = 'paper'; % this is 'paper' or 'presentation'
bworcolor = 'color'; % this is 'bw' or 'color'

filestring2 = strcat('../',filestring);

if time.end == ((120-1)*5)/60
    simt = 1:19:115;
end

%%% load experimental boundaries
if isempty(exp_boundary)==1
    exp_boundary = prep_expdata_bdy(strcat(filestring2,'boundaries.mat'),...
        exp_scale);
end
j = 0;
expbdy = cell(1,length(simt));
for i = simt
    j = j+1;
    if size(exp_boundary{i},1)>=5000
        expbdy{j} = exp_boundary{i}(1:55:end,:);
    elseif size(exp_boundary{i},1)>=3000
        expbdy{j} = exp_boundary{i}(1:45:end,:);
    elseif size(exp_boundary{i},1)>=2000
        expbdy{j} = exp_boundary{i}(1:25:end,:);
    elseif size(exp_boundary{i},1)>=1000
        expbdy{j} = exp_boundary{i}(1:15:end,:);
    elseif size(exp_boundary{i},1)>=600
        expbdy{j} = exp_boundary{i}(1:10:end,:);
    elseif size(exp_boundary{i},1)>=400
        expbdy{j} = exp_boundary{i}(1:8:end,:);
    elseif size(exp_boundary{i},1)>=300
        expbdy{j} = exp_boundary{i}(1:2:end,:);
    else
        expbdy{j} = exp_boundary{i};
    end
end

%%% numerical boundary
j = 0;
numbdyPhi = cell(1,length(simt));
for i = simt
    j = j+1;
    numbdyPhi{j} = Phi{i};
end


%%% figure
figure
for i = 1:length(simt)
    subaxis(1,length(simt),i,'Spacing', 0.01, 'Padding', 0, ...
        'PaddingTop',0.13, 'Margin', 0,'MarginRight',0,'MarginBottom',0.01)
    hold on
    
    if strcmp(imagetype,'paper')==1
        complinewidth = 3;
        expdotwidth = 7;
    elseif strcmp(imagetype,'presentation')==1
        complinewidth = 2;
        expdotwidth = 40;
    end
    
    
    lc = [1 0 0];%[0.5 0 0];
    dc = [0 0 1];%[1 1 0.8];
    if strcmp(bworcolor,'color')==1
        contour(g.x,g.y,numbdyPhi{i},[0 0],'Color',lc,'LineWidth',complinewidth)
        scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled','MarkerFaceColor',dc)
    elseif strcmp(bworcolor,'bw')==1
        lcbw = gsc(1)*lc(1) + gsc(2)*lc(2) + gsc(3)*lc(3);
        dcbw = gsc(1)*dc(1) + gsc(2)*dc(2) + gsc(3)*dc(3);
        contour(g.x,g.y,numbdyPhi{i},[0 0],'Color',[lcbw lcbw lcbw],'LineWidth',complinewidth)
        scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled','MarkerFaceColor',[dcbw dcbw dcbw])
    end
    
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    
    title([num2str((simt(i)-1)*5),' min'],'FontSize',24,'FontWeight','bold',...
        'Units','normalized','Position', [0.5,1]);
end

set(gcf,'Position',[100 700 200*length(simt) 200],'PaperPositionMode','auto');
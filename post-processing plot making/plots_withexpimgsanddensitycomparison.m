addpath ../mylib

imagetype = 'paper'; % this is 'paper' or 'presentation'

filestring2 = strcat('../',filestring);

if time.end == 690/60
    simt = [1 , 19:20:139];
elseif time.end == 395/60
    simt = [1 , 10:10:80];
elseif time.end == ((120-1)*5)/60
    simt = 1:23:119;
elseif time.end == ((109-1)*5)/60
    simt = 1:23:109;
elseif time.end == ((144-1)*5)/60;
    simt = 1:20:144;
end

%%% get experimental density ratios and boundary
if isempty(exp_densratio)==1
    [exp_densratio,exp_boundary] = prep_expdata(strcat(filestring2,...
        'densratios.mat'),strcat(filestring2,'boundaries.mat'),...
        exp_px);
end

%%% experimental boundary
j = 0;
expbdy = cell(1,length(simt));
for i = simt
    j = j+1;
    expbdy{j} = [exp_boundary{i} [exp_boundary{i}(1,1);exp_boundary{i}(2,1)]];
    if length(expbdy{j})>300
        expbdy{j} = expbdy{j}(:,1:2:end);
    end
    
    expbdy{j}(2,:) = -expbdy{j}(2,:);
end

%%% experimental density ratio
j = 0;
densratio_exp = cell(1,length(simt));
densratio_model = cell(1,length(simt));
difference = cell(1,length(simt));
maxs = zeros(1,length(simt));
mins = zeros(1,length(simt));
[row,col] = size(density{1});
for i = simt
    j = j+1;
    densratio_exp{j} = exp_densratio{1,i};
    densratio_model{j} = zeros(row,col);
    for m = 1:row
        for n = 1:col
            if density{i+1}(m,n)~=0
                densratio_model{j}(m,n) = density{i}(m,n)./density{i+1}(m,n);
            end
        end
    end
    densratio_model{j} = flipud(densratio_model{j});
    
    difference{j} = densratio_exp{j}-densratio_model{j};
    maxs(j) = max(max(difference{j}));
    mins(j) = min(min(difference{j}));
end

maxminlarge = max(abs(max(maxs)),abs(min(mins)));
maxdiff = maxminlarge;
mindiff = -maxminlarge;

%%% import experimental images
j = 0;
expimg = cell(1,length(simt));
for i = simt
    j = j+1;
    if strcmp(imagetype,'paper')==1
        if time.end == 395/60
            expimg{j} = imread(strcat(filestring2,'images/',num2str(59+i-1),...
                '.tif'),'tif');
        else
            expimg{j} = imread(strcat(filestring2,'images/',num2str(i-1),...
                '.tif'),'tif');
        end
    elseif strcmp(imagetype,'presentation')==1
        if time.end == 395/60
            expimg{j} = imread(strcat(filestring2,'images/regular size/',...
                num2str(59+i-1),'.tif'),'tif');
        else
            expimg{j} = imread(strcat(filestring2,'images/regular size/',...
                num2str(i-1),'.tif'),'tif');
        end
    end
end

%%% numerical boundary
j = 1;
numbdyPhi = cell(1,length(simt));
numbdyPhi{1} = Phi{1};
for i = simt(2:end)
    j = j+1;
    numbdyPhi{j} = Phi{i};
end



figure
for i = 1:length(simt)
    subaxis(1,length(simt),i,'Spacing', 0.01, 'Padding', 0, 'PaddingRight',0.03,'Margin', 0)
    if time.end == ((120-1)*5)/60 || time.end == ((109-1)*5)/60
        image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax])
    else
        image(flipud(expimg{i}),'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax])
    end
    colormap(gray(256))
    set(gca,'YDir','normal')
    hold on
    
    if strcmp(imagetype,'paper')==1
        complinewidth = 1;
        expdotwidth = 5;
    elseif strcmp(imagetype,'presentation')==1
        complinewidth = 2;
        expdotwidth = 40;
    end
    
%     if i==1
%         if time.end == ((120-1)*5)/60 || time.end == ((109-1)*5)/60
%         else
%             plot(expbdy{i}(1,:),expbdy{i}(2,:),'y','LineWidth',complinewidth)
%         end
%     else
        contour(g.x,g.y,numbdyPhi{i},[0 0],'y','LineWidth',complinewidth)
%     end
    scatter(expbdy{i}(1,:),expbdy{i}(2,:),expdotwidth,'c','filled')
    
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    
    if i==1
        title('\bf A','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
    elseif i==2
        title('\bf B','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
    elseif i==3
        title('\bf C','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
    elseif i==4
        title('\bf D','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
    elseif i==5
        title('\bf E','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
    elseif i==6
        title('\bf F','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
    else
        disp('need to add more letters to list');
    end
end
set(gcf,'Position',[100 700 200*length(simt) 150],'PaperPositionMode','auto');





for i = 1:length(simt)
    difference{i}(difference{i}==0) = NaN;
%     for m = 1:row
%         for n = 1:col
%             if difference{i}(m,n)==0
%                 difference{i}(m,n)= NaN;
%             end
%         end
%     end
end

figure
% load('MyColormaps','mycmap')
for i = 1:length(simt)
    subaxis(1,length(simt),i,'Spacing', 0.01, 'Padding', 0, ...
        'PaddingRight',0.03,'Margin', 0)
%     imagesc(densratio_exp{i}-densratio_model{i})
    imagescnan(difference{i},[mindiff maxdiff])
%     set(gcf,'Colormap',mycmap)
%     caxis([mindiff maxdiff])
    
    if i==length(simt)
        h = colorbar;
%         set(h, 'ylim', [mindiff maxdiff],'Location','East','Position',[.99,.05,.015,.9])
        set(h, 'Location','East','Position',[.99,.05,.015,.9])
    end
    
    set(gca,'XTick',[])
    set(gca,'YTick',[])
end
set(gcf,'Position',[200 400 200*length(simt) 150],'PaperPositionMode','auto');
addpath ../mylib

imagetype = 'paper'; % this is 'paper' or 'presentation'

filestring2 = strcat('../',filestring);

if time.end == 690/60
    simt = [1 , 19:20:139];
elseif time.end == 395/60
    simt = [1 , 10:10:80];
elseif time.end == ((120-1)*5)/60
    simt = 1:23:115;%1:23:119;
elseif time.end == ((109-1)*5)/60
    simt = 1:23:109;
elseif time.end == ((144-1)*5)/60;
    simt = 1:20:144;
end

%%% experimental boundary
exp_boundary = prep_expdata_bdyonly(strcat(filestring2,'boundaries.mat'),...
    exp_scale);

j = 0;
expbdy = cell(1,length(simt));
for i = simt
    j = j+1;
    expbdy{j} = [exp_boundary{i} [exp_boundary{i}(1,1);exp_boundary{i}(2,1)]];
    if length(expbdy{j})>300
        expbdy{j} = expbdy{j}(:,1:10:end);
    end
    
    expbdy{j}(2,:) = -expbdy{j}(2,:);
end

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

for i = 1:length(simt)
    figure(i+2)
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
    
    contour(g.x,g.y,numbdyPhi{i},[0 0],'y','LineWidth',complinewidth)
    scatter(expbdy{i}(1,:),expbdy{i}(2,:),expdotwidth,'c','filled')
    
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    
    if strcmp(imagetype,'paper')==1
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
        elseif i==7
            title('\bf G','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
        elseif i==8
            title('\bf H','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
        elseif i==9
            title('\bf I','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
        elseif i==10
            title('\bf J','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
        else
            disp('need to add more letters to list');
        end
    elseif strcmp(imagetype,'presentation')==1
        title(['hour: ',num2str(plot_times(simt(i)))],'FontSize',16,'Interpreter',...
            'latex')
    end
    
    if strcmp(imagetype,'paper')==1
        set(gca,'Units','pixels','Position',[0 0 200 200]); %axes
        set(gcf,'Position',[200 500 200 220],'PaperPositionMode','auto');
    elseif strcmp(imagetype,'presentation')==1
        set(gca,'Units','pixels','Position',[0 0 640 640]); %axes
        set(gcf,'Position',[200 500 640 680],'PaperPositionMode','auto');
    end
end
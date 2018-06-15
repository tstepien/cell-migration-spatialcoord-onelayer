addpath ../mylib

global g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figure options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imagetype = 'paper'; % this is 'paper' or 'presentation'
bworcolor = 'color'; % this is 'bw' or 'color'
jetcolormap = 0; % this is 1-yes or 0-no

numberoftimepts = 3; % this code is currently set up for 3 or 7 time points
timelabels = 'hr'; % min - labels on the top given in minutes
                    % hr - labels on the top given in hours

bothfigstogether = 'yes'; % yes - both figures are in the same window/file
                         % no - figures are separate windows/files
spaceforcolorbar = 'yes'; % yes - leave space for colorbar in A
                         % no - don't leave space for colorbar in A
                         %  (figures are separate, so A fills up all space)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frameIncrement = 5;

filestring2 = filestring;%strcat('../',filestring);

%%% time.end == ((120-1)*5)/60
if numberoftimepts==7
    simt = 1:19:115;
elseif numberoftimepts==3
    simt = 1:57:115;
end

%%% grayscale conversion (luminance): 0.299r + 0.587g + 0.114b
gsc = [0.299 0.587 0.114];

%%%%%%%%%%%%%%%%%%%%%%%% load experimental images %%%%%%%%%%%%%%%%%%%%%%%%%
j = 0;
expimg = cell(1,length(simt));
for i = simt
    j = j+1;
    expimg{j} = imread(strcat(filestring2,'images/img_000000',sprintf('%03d',i-1),...
        '_8Bit_000.tif'),'tif');
    % num2str(i-1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% density ratios %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load experimental density ratios
if isempty(exp_densratio)==1
    exp_densratio = prep_expdata_dens(strcat(filestring2,'densratios.mat'));
end

%%% numerical density ratio and comparison with experimental
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
    
    densratio_model{j} = density{i}./density{i+frameIncrement};
    densratio_model{j}(isnan(densratio_model{j})==1) = 0; %remove 0 divided by 0
    densratio_model{j}(isinf(densratio_model{j})==1) = 0; %remove divide by 0
    
    difference{j} = (densratio_exp{j}-densratio_model{j}) ...
        .* (densratio_exp{j}>0) .* (densratio_model{j}>0); % only include
                                                       % overlapping pixels
    maxs(j) = max(max(difference{j}));
    mins(j) = min(min(difference{j}));
end

maxminlarge = max(abs(max(maxs)),abs(min(mins)));
maxdiff = maxminlarge;
mindiff = -maxminlarge;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% boundaries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('MyColorMap_hot');

if strcmp(bothfigstogether,'yes')==1
    rowsinfig = 2;
elseif strcmp(bothfigstogether,'no')==1
    rowsinfig = 1;
end
if numberoftimepts==7
    spacing_horiz = 0.01;
    spacing_vert = 0.01;
    marginright = 0.05;
elseif numberoftimepts==3
    spacing_horiz = 0.02;
    spacing_vert = 0.01;
    marginright = 0.11;
end

%%% actual image and boundaries
figure
for i = 1:length(simt)
    if strcmp(spaceforcolorbar,'yes')==1
        marginright2 = marginright;
    elseif strcmp(spaceforcolorbar,'no')==1
        marginright2 = 0;
    end
    if strcmp(bothfigstogether,'yes')==1
        ax1 = subaxis(rowsinfig,length(simt),i,'SpacingHoriz', spacing_horiz, ...
            'SpacingVert', spacing_vert, 'Padding', 0, 'PaddingTop',0.065, ...
            'Margin', 0, 'MarginRight',marginright2,'MarginBottom',0.001);
    elseif strcmp(bothfigstogether,'no')==1
        ax1 = subaxis(rowsinfig,length(simt),i,'SpacingHoriz', spacing_horiz, ...
            'SpacingVert', spacing_vert, 'Padding', 0, 'PaddingTop',0.13, ...
            'Margin', 0, 'MarginRight',marginright2,'MarginBottom',0.01);
    end
    image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax]);
    colormap(ax1,gray(256))
    hold on
    
    if strcmp(imagetype,'paper')==1
        complinewidth = 3;
        expdotwidth = 7;
    elseif strcmp(imagetype,'presentation')==1
        complinewidth = 2;
        expdotwidth = 40;
    end
    
    
    lc = [0.5 0 0];
    dc = [1 1 0.8];
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
    
%     title([num2str((simt(i)-1)*5),' min'],'FontSize',14,'FontWeight','bold');
    if strcmp(timelabels,'min')==1
        title([num2str((simt(i)-1)*5),' min'],'FontSize',24,...
            'FontWeight','bold','Units','normalized','Position', [0.5,1]);
    elseif strcmp(timelabels,'hr')==1
        title([num2str((simt(i)-1)*5/60),' hr'],'FontSize',24,...
            'FontWeight','bold','Units','normalized','Position', [0.5,1]);
    end
    
%     if i==1
%         title('\bf A','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
%     elseif i==2
%         title('\bf B','FontSize',14,'Units','normalized','Position', [0.05 1.01]);
%     end
end

% annotation(gcf,'textbox',[0 0.905 0.0245714285714286 0.115],...
%     'String',{'H'},'FontWeight','bold','FontSize',22,...
%     'FontName','Helvetica','FitBoxToText','off','LineStyle','none');
% annotation(gcf,'textbox',[0 0.905 0.0245714285714286 0.115],...
%     'String',{'A'},'FontWeight','bold','FontSize',22,...
%     'FontName','Helvetica','FitBoxToText','off','LineStyle','none');

if numberoftimepts==7
    widthchange = 0;
elseif numberoftimepts==3
    widthchange = 32;
end

if strcmp(bothfigstogether,'no')==1
    set(gcf,'Position',[100 700 200*length(simt)+widthchange 200],...
        'PaperPositionMode','auto');
end



%%% density ratio differences
if strcmp(bothfigstogether,'no')==1
    figure
end
for i = 1:length(simt)
    difference{i}(difference{i}==0) = NaN;
    if strcmp(bothfigstogether,'no')==1
        ax2 = subaxis(rowsinfig,length(simt),i+length(simt)*(rowsinfig-1),...
            'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
            'Padding', 0, 'PaddingTop',0.07, ...
            'Margin', 0,'MarginRight',marginright,'MarginBottom',0.06);
    elseif strcmp(bothfigstogether,'yes')==1
        ax2 = subaxis(rowsinfig,length(simt),i+length(simt)*(rowsinfig-1),...
            'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
            'Padding', 0, 'PaddingTop',0.045, ...
            'Margin', 0,'MarginRight',marginright,'MarginBottom',0.03);
    end
    
    if strcmp(bworcolor,'color')==1
        if jetcolormap == 1
            difference{i}(abs(difference{i})>0.1)=NaN;
            imagescnan(difference{i})%[mindiff maxdiff])
        elseif jetcolormap == 0
            imagescnan(abs(difference{i}),[0,max(-mindiff,maxdiff)])
            colormap(ax2,flipud(bone))%flipud(pmkmp(64,'LinLhot')))
        end
    elseif strcmp(bworcolor,'bw')==1
        imagescnan(abs(difference{i}),[0,max(-mindiff,maxdiff)])
        load('colormap_grayscale')
        colormap(ax2,cmap)
    end
    
    if i==length(simt)
        h = colorbar;
        if strcmp(bothfigstogether,'no')==1
            if numberoftimepts==7
                set(h, 'Location','East','Position',[0.96,0.06,0.015,0.87])
            elseif numberoftimepts==3
                set(h, 'Location','East','Position',[0.91 0.06 0.0335 0.87])
            end
        elseif strcmp(bothfigstogether,'yes')==1
            if numberoftimepts==7
                set(h, 'Location','East','Position',[0.96,0.03,0.015,0.435])
            elseif numberoftimepts==3
                set(h, 'Location','East','Position',[0.91 0.03 0.0335 0.435])
            end
        end
    end
    
    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
end
% annotation(gcf,'textbox',[0 0.905 0.0245714285714286 0.115],...
%     'String',{'B'},'FontWeight','bold','FontSize',22,...
%     'FontName','Helvetica','FitBoxToText','off','LineStyle','none');

if strcmp(bothfigstogether,'no')==1
    set(gcf,'Position',[100 300 200*length(simt)+widthchange 200],...
        'PaperPositionMode','auto');
elseif strcmp(bothfigstogether,'yes')==1
    set(gcf,'Position',[100 300 200*length(simt)+widthchange 400],...
        'PaperPositionMode','auto');
end
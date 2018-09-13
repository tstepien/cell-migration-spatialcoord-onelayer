addpath ../mylib

global g;

%%% Pos9exp1 for paper Figure 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figure options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jetcolormap = 0; % this is 1-yes or 0-no

timelabels = 'hr'; % min - labels on the top given in minutes
                    % hr - labels on the top given in hours

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frameIncrement = 5;

filestring2 = filestring;%strcat('../',filestring);

simt = [58,115];

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

maxdensratio = max( [max(densratio_exp{1}(:)), max(densratio_exp{2}(:)),...
    max(densratio_model{1}(:)), max(densratio_model{1}(:))] );
mindensratio = min( [min(densratio_exp{1}(:)), min(densratio_exp{2}(:)),...
    min(densratio_model{1}(:)), min(densratio_model{1}(:))] );


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
paddingtop = [0.065,0.07];
marginbottom = [0.025,0.002];
spacing_horiz = 0.014;

fstitle = 18;

load('MyColorMap_hot');

%%% actual image and boundaries
figure
for i = 1:2
    %%% column 1: images
    ax1 = subaxis(2,5,1,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0, 'MarginBottom',marginbottom(i));

    image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax]);
    colormap(ax1,gray(256))
    
    set(gca,'XTick',[],'YTick',[])
    
    if strcmp(timelabels,'min')==1
        title([num2str((simt(i)-1)*5),' min'],'FontSize',24,...
            'FontWeight','bold','Units','normalized','Position', [0.5,1]);
    elseif strcmp(timelabels,'hr')==1
        title([num2str((simt(i)-1)*5/60),' hr'],'FontSize',24,...
            'FontWeight','bold','Units','normalized','Position', [0.5,1]);
    end
    
    
    %%% column 2: boundaries
    subaxis(2,5,2,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i));
    
    hold on
    
    complinewidth = 2;
    expdotwidth = 10;
    lc = [0.4940    0.1840    0.5560]; %purple
    dc = [0.4660    0.6740    0.1880]; %green
    contour(g.x,g.y,numbdyPhi{i},[0 0],'Color',lc,'LineWidth',complinewidth)
    scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled','MarkerFaceColor',dc)
    
    hold off
    
    set(gca,'XTick',[],'YTick',[],'Ydir','reverse')


    %%% column 3: density ratio from data
    ax3 = subaxis(2,5,3,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i));
    
    densratio_exp{i}(densratio_exp{i}==0) = NaN;
    imagescnan(densratio_exp{i},[mindensratio,maxdensratio])
    colormap(ax3,mymap_hot)%flipud(pmkmp(64,'LinLhot')))
    
    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        title('experimental data','FontSize',fstitle);
    end
    
    %%% column 4: density ratio from model
    ax4 = subaxis(2,5,4,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i));
    
    densratio_model{i}(densratio_model{i}==0) = NaN;
    imagescnan(densratio_model{i},[mindensratio,maxdensratio])
    colormap(ax4,mymap_hot)%flipud(pmkmp(64,'LinLhot')))
    
    if i==2
        h1 = colorbar;
        set(h1, 'Location','East','Position',[0.515 0.437 0.175 0.0268],...
            'Orientation','horizontal')
    end
    
    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    if i==1
        title('computational model','FontSize',fstitle);
    end
    
    %%% column 5: density ratio differences
    ax5 = subaxis(2,5,5,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginRight',0.0005,'MarginBottom',marginbottom(i));
    
    difference{i}(difference{i}==0) = NaN;
    if jetcolormap == 1
        difference{i}(abs(difference{i})>0.1)=NaN;
        imagescnan(difference{i})%[mindiff maxdiff])
    elseif jetcolormap == 0
        imagescnan(abs(difference{i}),[0,max(-mindiff,maxdiff)])
        colormap(ax5,flipud(bone))%flipud(pmkmp(64,'LinLhot')))
    end
    
    if i==2
        h2 = colorbar;
        set(h2, 'Location','East','Position',[0.817 0.437 0.175 0.0268],...
            'Orientation','horizontal')
    end
    
    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    if i==1
        title('absolute difference','FontSize',fstitle);
    end
    
end

set(gcf,'Position',[100 300 200*5-55 410],'PaperPositionMode','auto');
addpath ../mylib

global g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figure options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jetcolormap = 0; % this is 1-yes or 0-no

timelabels = 'hr'; % min - labels on the top given in minutes
                    % hr - labels on the top given in hours

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frameIncrement = 5;

filestring = '../experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos2_exp1/';

number_nodes = 100;
exp_px = [492,504];
exp_scale = .177;
g = mesh_generation(number_nodes,exp_px,exp_scale);

tplot = [1,58,115];

%%%%%%%%%%%%%%%%%%%%%%%% load experimental images %%%%%%%%%%%%%%%%%%%%%%%%%
expimg = cell(1,length(tplot));
j = 0;
for i = tplot
    j = j+1;
    expimg{j} = imread(strcat(filestring,'images/img_000000',sprintf('%03d',i-1),...
        '_8Bit_000.tif'),'tif');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% load strains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsx = cell(1,length(tplot));
epsy = cell(1,length(tplot));
epsxy = cell(1,length(tplot));
epsyx = cell(1,length(tplot));
maxs_ep = zeros(length(tplot),4);
mins_ep = zeros(length(tplot),4);
j = 0;
for i = tplot
    j = j+1;
    epsx{j} = imread(strcat(filestring,'strains/epsx_',num2str(tplot(j)),'.tif'),'tif');
    epsy{j} = imread(strcat(filestring,'strains/epsy_',num2str(tplot(j)),'.tif'),'tif');
    epsxy{j} = imread(strcat(filestring,'strains/epsxy_',num2str(tplot(j)),'.tif'),'tif');
    epsyx{j} = imread(strcat(filestring,'strains/epsyx_',num2str(tplot(j)),'.tif'),'tif');
    
    maxs_ep(j,:) = [max(max(epsx{j})) , max(max(epsy{j})) , ...
        max(max(epsxy{j})) , max(max(epsyx{j}))];
    mins_ep(j,:) = [min(min(epsx{j})) , min(min(epsy{j})) , ...
        min(min(epsxy{j})) , min(min(epsyx{j}))];
end
max_ep = max(maxs_ep(:));
min_ep = min(mins_ep(:));
bnds = max(abs(min_ep),abs(max_ep));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% density ratios %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load experimental density ratios
exp_densratio = prep_expdata_dens(strcat(filestring,'densratios.mat'));

%%% numerical density ratio and comparison with experimental
j = 0;
densratio_exp = cell(1,length(tplot));
maxs = zeros(1,length(tplot));
mins = zeros(1,length(tplot));

for i = tplot
    j = j+1;
    densratio_exp{j} = exp_densratio{1,i};
    maxs(j) = max(max(densratio_exp{j}));
    mins(j) = min(min(densratio_exp{j}));
end

maxminlarge = max(abs(max(maxs)),abs(min(mins)));
maxdiff = maxminlarge;
mindiff = -maxminlarge;

maxdensratio = max( [max(densratio_exp{1}(:)), max(densratio_exp{2}(:))] );
mindensratio = min( [min(densratio_exp{1}(:)), min(densratio_exp{2}(:))] );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% boundaries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load experimental boundaries
exp_boundary = prep_expdata_bdy(strcat(filestring,'boundaries.mat'),...
    exp_scale);
j = 0;
expbdy = cell(1,length(tplot));
for i = tplot
    j = j+1;
    expbdy{j} = exp_boundary{i};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
paddingtop = [0.044,0.04,0.04];
marginbottom = [-0.01,0,0.002];
marginright = [0.055*ones(1,5),0.055,0.026];
spacing_horiz = 0.005;

load('MyColorMap_RB');
load('MyColorMap_hot');

figure
for i = 1:3
    %%% column 1: images
    ax1 = subaxis(3,7,1,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0, 'MarginBottom',marginbottom(i),'MarginRight',marginright(1));

    image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax]);
    colormap(ax1,gray(256))
    
    set(gca,'XTick',[],'YTick',[])
    
    if strcmp(timelabels,'min')==1
        title([num2str((tplot(i)-1)*5),' min'],'FontSize',24,...
            'FontWeight','bold','Units','normalized','Position', [0.5,1]);
    elseif strcmp(timelabels,'hr')==1
        title([num2str((tplot(i)-1)*5/60),' hr'],'FontSize',24,...
            'FontWeight','bold','Units','normalized','Position', [0.5,1]);
    end
    
    
    %%% column 2: boundaries
    subaxis(3,7,2,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i),'MarginRight',marginright(2));
    
    complinewidth = 2;
    expdotwidth = 10;
    scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled',...
        'MarkerFaceColor',[0.4 0.4 0.4])
    box on
    
    set(gca,'XTick',[],'YTick',[],'XLim',[g.xmin,g.xmax],...
        'YLim',[g.ymin,g.ymax],'Ydir','reverse')
    
    %%% column 3: epsx data
    ax3 = subaxis(3,7,3,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i),'MarginRight',marginright(3));
    
    epsx{i}(epsx{i}==0) = NaN;
    imagescnan(epsx{i},[-bnds,bnds])
    colormap(ax3,mymap_RB)

    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        title('$\epsilon_{xx}$','FontSize',24,'Interpreter','latex');
    end
    
    %%% column 4: epsy data
    ax4 = subaxis(3,7,4,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i),'MarginRight',marginright(4));
    
    epsy{i}(epsy{i}==0) = NaN;
    imagescnan(epsy{i},[-bnds,bnds])
    colormap(ax4,mymap_RB)

    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        title('$\epsilon_{yy}$','FontSize',24,'Interpreter','latex');
    end
    
    %%% column 5: epsxy data
    ax5 = subaxis(3,7,5,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i),'MarginRight',marginright(5));
    
    epsxy{i}(epsxy{i}==0) = NaN;
    imagescnan(epsxy{i},[-bnds,bnds])
    colormap(ax5,mymap_RB)

    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        title('$\epsilon_{xy}$','FontSize',24,'Interpreter','latex');
    end
    
    %%% column 6: epsyx data
    ax6 = subaxis(3,7,6,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i),'MarginRight',marginright(6));
    
    epsyx{i}(epsyx{i}==0) = NaN;
    imagescnan(epsyx{i},[-bnds,bnds])
    colormap(ax6,mymap_RB)
    
    if i==2
        h6 = colorbar;
        set(h6, 'Location','East', 'Position',[0.811 0.337 0.006 0.287]);
    end

    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    if i==1
        title('$\epsilon_{yx}$','FontSize',24,'Interpreter','latex');
    end
    
    

    %%% column 7: density ratio from data
    ax7 = subaxis(3,7,7,i,'SpacingHoriz', spacing_horiz, 'SpacingVert', 0.01, ...
        'Padding', 0, 'PaddingTop',paddingtop(i), ...
        'Margin', 0,'MarginBottom',marginbottom(i),'MarginRight',marginright(7));
    
    densratio_exp{i}(densratio_exp{i}==0) = NaN;
    imagescnan(densratio_exp{i},[mindensratio,maxdensratio])
    colormap(ax7,mymap_hot)%flipud(pmkmp(64,'LinLhot')))
    
    if i==2
        h7 = colorbar;
        set(h7, 'Location','East', 'Position',[0.976 0.337 0.006 0.287]);
    end
    
    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    if i==1
        title('density ratio','FontSize',18);
    end
end

set(gcf,'Position',[100 300 200*7 600],'PaperPositionMode','auto');
addpath ../mylib

global g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figure options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jetcolormap = 0; % this is 1-yes or 0-no

timelabels = 'hr'; % min - labels on the top given in minutes
                    % hr - labels on the top given in hours

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frameIncrement = 5;

filestring = '../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos2_exp1/';

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
spacing_horiz = 0.05;
spacing_vert = 0.005;
marginright = [0,0.12,0.16];
paddingtopothers = 0.015;
paddingleft = [0.07,0.03,0.015];

load('MyColorMap_RB');
load('MyColorMap_hot');

figure
for i = 1:3
    %%% row 1: images
    ax1 = subaxis(7,3,i,1,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.03,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i),'MarginBottom',-0.13);

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
    
    
    %%% row 2: boundaries
    subaxis(7,3,i,2,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.02,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i),'MarginBottom',-0.05);
    
    complinewidth = 2;
    expdotwidth = 10;
    scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled',...
        'MarkerFaceColor',[0.4 0.4 0.4])
    box on
    
    set(gca,'XTick',[],'YTick',[],'XLim',[g.xmin,g.xmax],...
        'YLim',[g.ymin,g.ymax],'Ydir','reverse')

    
    %%% row 3: epsx data
    ax3 = subaxis(7,3,i,3,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.015,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i),'MarginBottom',-0.02);
    
    epsx{i}(epsx{i}==0) = NaN;
    imagescnan(epsx{i},[-bnds,bnds])
    colormap(ax3,mymap_RB)

    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        ylabel('$\epsilon_{xx}$','FontSize',24,'Interpreter','latex');
    end
    
    %%% row 4: epsy data
    ax4 = subaxis(7,3,i,4,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.012,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i),'MarginBottom',-0.005);
    
    epsy{i}(epsy{i}==0) = NaN;
    imagescnan(epsy{i},[-bnds,bnds])
    colormap(ax4,mymap_RB)

    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        ylabel('$\epsilon_{yy}$','FontSize',24,'Interpreter','latex');
    end
    
    %%% row 5: epsxy data
    ax5 = subaxis(7,3,i,5,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.01,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i));
    
    epsxy{i}(epsxy{i}==0) = NaN;
    imagescnan(epsxy{i},[-bnds,bnds])
    colormap(ax5,mymap_RB)

    set(gca,'XTick',[],'YTick',[])
    
    if i==1
        ylabel('$\epsilon_{xy}$','FontSize',24,'Interpreter','latex');
    end
    
    %%% row 6: epsyx data
    ax6 = subaxis(7,3,i,6,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.012,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i),'MarginBottom',0.005);
    
    epsyx{i}(epsyx{i}==0) = NaN;
    imagescnan(epsyx{i},[-bnds,bnds])
    colormap(ax6,mymap_RB)
    
    if i==2
        h6 = colorbar;
        set(h6, 'Location','East', 'Position',[0.869 0.3587 0.037 0.12803]);
    end

    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    if i==1
        ylabel('$\epsilon_{yx}$','FontSize',24,'Interpreter','latex');
    end
    
    

    %%% row 7: density ratio from data
    ax7 = subaxis(7,3,i,7,'SpacingHoriz', spacing_horiz, 'SpacingVert', spacing_vert, ...
        'Padding', 0, 'PaddingTop',0.01,'PaddingLeft',paddingleft(i), ...
        'Margin', 0,'MarginRight',marginright(i),'MarginBottom',0.01);
    
    densratio_exp{i}(densratio_exp{i}==0) = NaN;
    imagescnan(densratio_exp{i},[mindensratio,maxdensratio])
    colormap(ax7,mymap_hot)%flipud(pmkmp(64,'LinLhot')))
    
    if i==2
        h7 = colorbar;
        set(h7, 'Location','East', 'Position',[0.869 0.0093 0.041998 0.12803]);
    end
    
    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    if i==1
        ylabel('density ratio','FontSize',16,'FontWeight','bold');
    end
end

set(gcf,'Position',[100 300 500 750],'PaperPositionMode','auto');
clc
clear variables

addpath ../mylib

global g;

frameIncrement = 5;

filestring = '../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos2_exp1/';
sizegapdata = 0;

number_nodes = 100;
exp_px = [492,504];
exp_scale = .177;
g = mesh_generation(number_nodes,exp_px,exp_scale);

simt = 1:115;

nFrames = length(simt);
mov(1:nFrames) = struct('cdata',[],'colormap',[]);

%%%%%%%%%%%%%%%%%%%%%%%% load experimental images %%%%%%%%%%%%%%%%%%%%%%%%%
expimg = cell(1,length(simt));
for i = simt
    expimg{i} = imread(strcat(filestring,'images/Pos2exp1.tif'),'tif',i);
end

%%%%%%%%%%%%%%%%%%%%%%%% load experimental strains %%%%%%%%%%%%%%%%%%%%%%%%
epsx = cell(1,length(simt));
epsy = cell(1,length(simt));
epsxy = cell(1,length(simt));
maxs_ep = zeros(length(simt),3);
mins_ep = zeros(length(simt),3);
for i = simt
    epsx{i} = imread(strcat(filestring,'strains/epsx_crop.tif'),'tif',i);
    epsx{i}(epsx{i}==0) = NaN;
    epsy{i} = imread(strcat(filestring,'strains/epsy_crop.tif'),'tif',i);
    epsy{i}(epsy{i}==0) = NaN;
    epsxy{i} = imread(strcat(filestring,'strains/epsxy_crop.tif'),'tif',i);
    epsxy{i}(epsxy{i}==0) = NaN;
    
    maxs_ep(i,:) = [max(max(epsx{i})) , max(max(epsy{i})) , ...
        max(max(epsxy{i}))];
    mins_ep(i,:) = [min(min(epsx{i})) , min(min(epsy{i})) , ...
        min(min(epsxy{i}))];
end
max_ep = max(maxs_ep(:));
min_ep = min(mins_ep(:));
bnds = max(abs(min_ep),abs(max_ep));

%%%%%%%%%%%%%%%%%%%%%%%%% load experimental data %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load experimental density ratios
exp_densratio = prep_expdata_dens(strcat(filestring,'densratios.mat'));
maxs = zeros(1,length(simt));
mins = zeros(1,length(simt));

for i = simt
    exp_densratio{i}(exp_densratio{i}==0) = NaN;
    maxs(i) = max(max(exp_densratio{i}));
    mins(i) = min(min(exp_densratio{i}));
end

maxminlarge = max(abs(max(maxs)),abs(min(mins)));
maxdiff = maxminlarge;
mindiff = -maxminlarge;

maxdensratio = max( [max(exp_densratio{1}(:)), max(exp_densratio{2}(:))] );
mindensratio = min( [min(exp_densratio{1}(:)), min(exp_densratio{2}(:))] );

%%% load experimental boundaries
exp_boundary = prep_expdata_bdy(strcat(filestring,'boundaries.mat'),...
    exp_scale);
expbdy = cell(1,length(simt));
for i = simt
    expbdy{i} = exp_boundary{i};
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% movies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('MyColorMap_RB');
load('MyColorMap_hot');
h1 = [];
h2 = [];
h6 = [];

figure
set(gcf,'Position',[440,378,700,450]);

for i = 1:length(simt)
    set(gca,'nextplot','replacechildren');
    delete(h1);
    delete(h2);
    delete(h6);
    
%%%%%%% actual image
    plotimg = subaxis(2,3,1,'MarginLeft',0.01,'MarginRight',0.05,...
        'MarginTop',0.06,'MarginBottom',0.02);
    image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax])
    colormap(plotimg,gray(256))
    
    xlimplot = get(gca,'XLim');
    ylimplot = get(gca,'YLim');
    xticks([]);
    yticks([]);
    
    %%% scale bar
    h1 = annotation(gcf,'textbox',[0.002 0.446 0.1 0.065],...
        'String',{'500 \mum'},'LineStyle','none','FontSize',16);
    
    scalewidth = 500; %micron
    if exp_px(1) > 800 %sizegapdata Pos 8
        scaleheight = 60;
        amtmovetoaxes = 40;
    elseif exp_px(1) > 700
        scaleheight = 150;
        amtmovetoaxes = 100;
    elseif exp_px(1) > 500
        scaleheight = 90;
        amtmovetoaxes = 75;
    elseif exp_px(1) > 350
        scaleheight = 60;
        amtmovetoaxes = 50;
    else
        scaleheight = 40;
        amtmovetoaxes = 25;
    end
    if sizegapdata==0
        fc = [0,0,0];
    elseif sizegapdata==1
        fc = [1,1,1];
    end
    rectangle('Position',[xlimplot(1)+amtmovetoaxes,...
        ylimplot(2)-scaleheight-amtmovetoaxes,scalewidth,scaleheight],...
        'FaceColor',fc)
    
    title([num2str((simt(i)-1)*5),' min'],'FontSize',24,'FontWeight','bold');
    
%%%%%%% strains - xx
    ax2 = subaxis(2,3,2,'MarginRight',0.08);
    imagescnan(epsx{i},[-bnds,bnds])
    colormap(ax2,mymap_RB)
    
    title('$\epsilon_{xx}$','Interpreter','latex','FontSize',20)

    set(gca,'XTick',[],'YTick',[])
    
%%%%%%% strains - xy
    ax2 = subaxis(2,3,3,'MarginRight',0.09);
    imagescnan(epsxy{i},[-bnds,bnds])
    colormap(ax2,mymap_RB)
    
    title('$\epsilon_{xy}=\epsilon_{yx}$','Interpreter','latex','FontSize',20)

    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    h2 = colorbar;
    set(h2, 'Location','East', 'Position',[0.92173 0.5056 0.021 0.434]);
    
%%%%%%% boundaries
    subaxis(2,3,4,'MarginBottom',0.015,'MarginTop',0.065,'MarginRight',0.05);
    complinewidth = 2;
    expdotwidth = 10;
    scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled',...
        'MarkerFaceColor',[0.4 0.4 0.4])
    box on
    
    set(gca,'XTick',[],'YTick',[],'XLim',[g.xmin,g.xmax],...
        'YLim',[g.ymin,g.ymax],'Ydir','reverse')
    
%%%%%%% strains - xy
    ax5 = subaxis(2,3,5,'MarginRight',0.08);
    imagescnan(epsy{i},[-bnds,bnds])
    colormap(ax5,mymap_RB)
    
    title('$\epsilon_{yy}$','Interpreter','latex','FontSize',20)

    set(gca,'XTick',[],'YTick',[])
    
%%% density ratios
    ax6 = subaxis(2,3,6,'MarginRight',0.09);
    imagescnan(exp_densratio{i},[0,maxdensratio])
    colormap(ax6,mymap_hot)
    
    title('density ratio')
    
    set(gca,'XTick',[],'YTick',[],'FontSize',16)
    
    h6 = colorbar;
    set(h6, 'Location','East', 'Position',[0.92173 0.0144 0.021 0.436]);
    
    mov(i) = getframe(gcf);
end

v = VideoWriter('xenopusstrainsmov.avi','Motion JPEG AVI');%,'Uncompressed AVI');
v.FrameRate = 10;
open(v);
writeVideo(v,mov)
close(v);
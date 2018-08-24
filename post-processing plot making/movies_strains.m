clc

addpath ../mylib

global g;

frameIncrement = 5;

% filestring = '../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos2_exp1/';
filestring = '../../../../Desktop/RESEARCH!!!/researchdata/experimental_data/100714 Animal cap x0.8 Scion x2_0/Pos0/';

number_nodes = 100;
% exp_px = [492,504];
exp_px = [767,848];
exp_scale = .177;
g = mesh_generation(number_nodes,exp_px,exp_scale);

simt = 1:115;

nFrames = length(simt);
mov(1:nFrames) = struct('cdata',[],'colormap',[]);

%%%%%%%%%%%%%%%%%%%%%%%% load experimental images %%%%%%%%%%%%%%%%%%%%%%%%%
expimg = cell(1,length(tplot));
j = 0;
for i = tplot
    j = j+1;
    expimg{j} = imread(strcat(filestring,'images/img_000000',sprintf('%03d',i-1),...
        '_8Bit_000.tif'),'tif');
end

%%%%%%%%%%%%%%%%%%%%%%%%% load experimental data %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load experimental density ratios
exp_densratio = prep_expdata_dens(strcat(filestring,'densratios.mat'));

%%% load experimental boundaries
exp_boundary = prep_expdata_bdy(strcat(filestring,'boundaries.mat'),...
    exp_scale);
j = 0;
expbdy = cell(1,length(tplot));
for i = tplot
    j = j+1;
    expbdy{j} = exp_boundary{i};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% movies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
set(gcf,'Position',[440,378,700,450]);

for i = 1%:length(simt)
    set(gca,'nextplot','replacechildren');
    
%%%%%%% actual image
    plotimg = subaxis(2,3,1,'MarginLeft',0.01,'MarginRight',0.05);
    image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax])
    colormap(plotimg,gray(256))
    
    xlimplot = get(gca,'XLim');
    ylimplot = get(gca,'YLim');
    xticks([]);
    yticks([]);
    
    %%% scale bar
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
    
    title([num2str((simt(i)-1)*5),' min'],'FontSize',24,'FontWeight','bold',...
        'Units','normalized','HorizontalAlignment', 'right',...
        'Position',[0.325,1.02]);
    
%%%%%%% boundaries
    subaxis(2,3,4);
    complinewidth = 2;
    expdotwidth = 10;
    scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled',...
        'MarkerFaceColor',[0.4 0.4 0.4])
    box on
    
    set(gca,'XTick',[],'YTick',[],'XLim',[g.xmin,g.xmax],...
        'YLim',[g.ymin,g.ymax],'Ydir','reverse')
    
    mov(i) = getframe(gcf);
end

v = VideoWriter('xenopusstrainsmov.avi','Motion JPEG AVI');%,'Uncompressed AVI');
v.FrameRate = 10;
open(v);
writeVideo(v,mov)
close(v);
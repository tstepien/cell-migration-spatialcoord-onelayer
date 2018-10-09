addpath ../mylib

global g;

sizegapdata = 1/2; % 1:yes, 0:no %1/2:pos11exp1, pos6exp3, pos6, pos2exp1

frameIncrement = 5;

filestring2 = filestring;%strcat('../',filestring);

simt = 1:115;

nFrames = length(simt);
mov(1:nFrames) = struct('cdata',[],'colormap',[]);

%%%%%%%%%%%%%%%%%%%%%%%% load experimental images %%%%%%%%%%%%%%%%%%%%%%%%%
j = 0;
expimg = cell(1,length(simt));
for i = simt
    j = j+1;
    if sizegapdata==0
        if i==1
            expimg{j} = imread(strcat(filestring2,'images/img_000000',...
                sprintf('%03d',i-1),'_8Bit_000 copy.tif'),'tif');
        else
            expimg{j} = imread(strcat(filestring2,'images/img_000000',...
                sprintf('%03d',i-1),'_8Bit_000.tif'),'tif');
        end
    elseif sizegapdata==1
        expimg{j} = imread(strcat(filestring2,'images/img_000000',...
            sprintf('%03d',i-1),'__000.tif'),'tif');
    elseif sizegapdata==1/2
        if j==1
            whichpos = num2str(input('Which Pos? '));
            whichexp = num2str(input('Which exp? '));
        end
        if strcmp(whichexp,'0')==1
            expimg{j} = imread(strcat('../../../../Desktop/RESEARCH!!!/researchdata',...
                '/experimental_data/SizeGapData/2014_02_21/Pos6/images/Pos6.tif'),j);
        else
            expimg{j} = imread(strcat('../../../../Desktop/RESEARCH!!!/movies - xenopus',...
                '/Shirley Ma/100714 Animal cap x0.8 Scion x2_0/100714 Animal cap x0.8 Scion x2_0',...
                '/explants separated/Pos',whichpos,'_exp',whichexp,'/Pos',...
                whichpos,'exp',whichexp,'.tif'),j);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%% load experimental data %%%%%%%%%%%%%%%%%%%%%%%%%%

exp_densratio = prep_expdata_dens(strcat(filestring2,'densratios.mat'));
exp_boundary = prep_expdata_bdy(strcat(filestring2,'boundaries.mat'),...
    exp_scale);
L = length(exp_densratio);

diff_densratio = cell(1,L);
avgnorm_densratio = zeros(1,L);
diff_dist = cell(1,L+frameIncrement);
avgnorm_dist = zeros(1,L+frameIncrement);

for i = 1:L
    num_densratio = density{i}./density{i+frameIncrement};
    num_densratio(isnan(num_densratio)==1) = 0; %remove 0 divided by 0
    num_densratio(isinf(num_densratio)==1) = 0; %remove divide by 0
    diff_densratio{i} = abs(num_densratio - exp_densratio{i});
    avgnorm_densratio(i) = norm(diff_densratio{i}(:)/sum(diff_densratio{i}(:)>0));
    
    diff_dist{i} = find_dist_twofullcurves(curve{i},exp_boundary{i});
    avgnorm_dist(i) = norm(diff_dist{i}/length(diff_dist{i}));
end

for i = L+1:L+frameIncrement %add in extra frames for boundaries
    diff_dist{i} = find_dist_twofullcurves(curve{i},exp_boundary{i});
    avgnorm_dist(i) = norm(diff_dist{i}/length(diff_dist{i}));
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% movies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
set(gcf,'Position',[440,378,700,400]);

annotation(gcf,'textbox',[0.002 0.035 0.1 0.065],...
    'String',{'500 \mum'},'LineStyle','none','FontSize',16);

annotation(gcf,'textbox',[0.142 0.0225 0.18 0.06],...
    'String','Boundary Error:','LineStyle','none','FontSize',16,...
    'HorizontalAlignment','right');
annotation(gcf,'textbox',[0.53 0.0225 0.23 0.06],...
    'String','Density Ratios Error:','LineStyle','none','FontSize',16,...
    'HorizontalAlignment','right');
h1 = [];
h2 = [];

for i = 1:length(simt)
    set(gca,'nextplot','replacechildren');
    delete(h1);
    delete(h2);
    
%%%%%%% actual image and boundaries
    plotbdy = subaxis(1,2,1,'MarginLeft',0.01,'MarginRight',0.05);
    image(expimg{i},'XData',[g.xmin g.xmax],'YData',[g.ymin g.ymax])
    colormap(plotbdy,gray(256))
    hold on
    
    complinewidth = 3;
    expdotwidth = 7;
    
    contour(g.x,g.y,numbdyPhi{i},[0 0],'Color',[0.5 0 0],'LineWidth',complinewidth)
    scatter(expbdy{i}(:,1),expbdy{i}(:,2),expdotwidth,'filled','MarkerFaceColor',[1 1 0.8])
    
    hold off
    
    set(gca,'FontSize',16);
    lgd = legend({'Simulation','Experiment'},'Color',[0.8 0.8 0.8],...
        'Position',[0.290714276307122 0.901249988279957 0.164285714285714 0.09875]);
    
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
    if sizegapdata==0 || (sizegapdata==1/2 && strcmp(whichexp,'0')~=1)
        fc = [0,0,0];
    elseif sizegapdata==1 || (sizegapdata==1/2 && strcmp(whichexp,'0')==1)
        fc = [1,1,1];
    end
    rectangle('Position',[xlimplot(1)+amtmovetoaxes,...
        ylimplot(2)-scaleheight-amtmovetoaxes,scalewidth,scaleheight],...
        'FaceColor',fc)
    
    title([num2str((simt(i)-1)*5),' min'],'FontSize',24,'FontWeight','bold',...
        'Units','normalized','HorizontalAlignment', 'right',...
        'Position',[0.325,1.02]);
    
    h1 = annotation(gcf,'textbox',[0.315 0.0175 0.16 0.06],...
        'String',strcat('$D_{',num2str(i),'}\!=$',num2str(avgnorm_dist(i))),...
        'LineStyle','none','FontSize',16,'HorizontalAlignment','left',...
        'Interpreter','latex');
    
%%%%%%% density ratio differences
    plotdens = subaxis(1,2,2,'MarginRight',0.03,'MarginLeft',-0.09);
    difference{i}(difference{i}==0) = NaN;
    
    imagescnan(difference{i},[0,max(-mindiff,maxdiff)])
    colormap(plotdens,flipud(pmkmp(64,'LinLhot')))
    colorbar;
    
    xticks([]);
    yticks([]);
    set(gca,'FontSize',16)
    
    h2 = annotation(gcf,'textbox',[0.755 0.0175 0.18 0.06],...
        'String',strcat('$P_{',num2str(i),'}\!=$',num2str(avgnorm_densratio(i))),...
        'LineStyle','none','FontSize',16,'HorizontalAlignment','left',...
        'Interpreter','latex');
    
    mov(i) = getframe(gcf);
end

v = VideoWriter('xenopusmov.avi','Motion JPEG AVI');%,'Uncompressed AVI');
v.FrameRate = 10;
open(v);
writeVideo(v,mov)
close(v);
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

maxs = zeros(length(simt),1);
mins = zeros(length(simt),1);
c = cell(1,length(simt));
for i = 1:length(simt)
    c{i} = curvature{simt(i)};
    maxs(i) = max(max(c{i}));
    mins(i) = min(min(c{i}));
    
    c{i}(c{i}==0) = NaN;
end

maxminlarge = max(abs(max(maxs)),abs(min(mins)));
maxdiff = maxminlarge;
mindiff = -maxminlarge;


figure
for i = 1:length(simt)
    subaxis(1,length(simt),i,'Spacing', 0.01, 'Padding', 0, ...
        'PaddingRight',0.03,'Margin', 0)
    imagescnan(c{i},[mindiff maxdiff])
    
    if i==length(simt)
        h = colorbar;
        set(h, 'Location','East','Position',[.99,.05,.015,.9])
    end
    
    set(gca,'XTick',[])
    set(gca,'YTick',[])
end
set(gcf,'Position',[200 400 200*length(simt) 150],'PaperPositionMode','auto');
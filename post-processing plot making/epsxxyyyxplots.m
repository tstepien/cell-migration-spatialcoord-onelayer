% clear all
% clc
% L = 143;
% 
% epsx = cell(1,L);
% epsxy = cell(1,L);
% epsy = cell(1,L);
% epsyx = cell(1,L);
% 
% minx = zeros(1,L);
% minxy = zeros(1,L);
% miny = zeros(1,L);
% minyx = zeros(1,L);
% 
% maxx = zeros(1,L);
% maxxy = zeros(1,L);
% maxy = zeros(1,L);
% maxyx = zeros(1,L);
% 
% for i = 1:L
%     epsx{i}=imread('epsx.tif','tif',i);
%     epsx{i}(1,1) = 0;
%     epsx{i}(2,1) = 0;
%     minx(i) = min(min(epsx{i}(epsx{i}>0)));
%     maxx(i) = max(max(epsx{i}));
%     epsx{i}(epsx{i}==0) = NaN;
%     
%     epsxy{i}=imread('epsxy.tif','tif',i);
%     epsxy{i}(1,1) = 0;
%     epsxy{i}(2,1) = 0;
%     minxy(i) = min(min(epsxy{i}(epsxy{i}>0)));
%     maxxy(i) = max(max(epsxy{i}));
%     epsxy{i}(epsxy{i}==0) = NaN;
%     
%     epsy{i}=imread('epsy.tif','tif',i);
%     epsy{i}(1,1) = 0;
%     epsy{i}(2,1) = 0;
%     miny(i) = min(min(epsy{i}(epsy{i}>0)));
%     maxy(i) = max(max(epsy{i}));
%     epsy{i}(epsy{i}==0) = NaN;
%     
%     epsyx{i}=imread('epsyx.tif','tif',i);
%     epsyx{i}(1,1) = 0;
%     epsyx{i}(2,1) = 0;
%     minyx(i) = min(min(epsyx{i}(epsyx{i}>0)));
%     maxyx(i) = max(max(epsyx{i}));
%     epsyx{i}(epsyx{i}==0) = NaN;
% end
% 
% minminx = min(minx);
% maxmaxx = max(maxx);
% 
% minminxy = min(minxy);
% maxmaxxy = max(maxxy);
% 
% minminy = min(miny);
% maxmaxy = max(maxy);
% 
% minminyx = min(minyx);
% maxmaxyx = max(maxyx);

%%% dynamic colorbar
for i = 1:L
    h = figure;
    imagescnan(epsxy{i},[minxy(i) maxxy(i)]);
    colormap('jet')
    colorbar

    filename = strcat('epsxy_plots/dynamic/',num2str(i-1),'.tiff');

    print(h,'-dtiffn',filename,'-r50')
    
    close all
    
    
    
    
    h = figure;
    imagescnan(epsy{i},[miny(i) maxy(i)]);
    colormap('jet')
    colorbar

    filename = strcat('epsy_plots/dynamic/',num2str(i-1),'.tiff');

    print(h,'-dtiffn',filename,'-r50')
    
    close all
    
    
    
    
    h = figure;
    imagescnan(epsyx{i},[minyx(i) maxyx(i)]);
    colormap('jet')
    colorbar

    filename = strcat('epsyx_plots/dynamic/',num2str(i-1),'.tiff');

    print(h,'-dtiffn',filename,'-r50')
    
    close all
end

%%% static colorbar
% for i = 1:L
%     h = figure;
%     imagescnan(epsx{i},[minminx maxmaxx]);
%     colormap('jet')
%     if i==1
%         colorbar
%     end
% 
%     filename = strcat('epsx_plots/static/',num2str(i-1),'.tiff');
% 
%     print(h,'-dtiffn',filename,'-r50')
%     
%     close all
% end
filestring = '../../../../../../RESEARCH!!!/researchdata/experimental_data/2014-06-11_ACTriangles/Pos4/';

load(strcat(filestring,'densratios.mat'));

L = length(exp_densratios);
dens = exp_densratios;

minvals = zeros(L,1);
maxvals = zeros(L,1);

for i = 1:L
    minvals(i) = min(min(exp_densratios{i}(exp_densratios{i}>0)));
    maxvals(i) = max(max(exp_densratios{i}));
    
    dens{i}(dens{i}==0)=NaN;
end

minval = min(minvals);
maxval = max(maxvals);

%%% dynamic colorbar
% for i = 1:L
%     h = figure;
%     imagescnan(dens{i},[minvals(i) maxvals(i)]);
%     colorbar
% 
%     filename = strcat('../../../../../../densityratioplots/',num2str(i-1),'.tiff');
% 
%     print(h,'-dtiffn',filename,'-r50')
%     
%     close all
% end

%%% static colorbar
for i = 1:L
    h = figure;
    imagescnan(dens{i},[minval maxval]);
    if i==1
        colorbar
    end

    filename = strcat('../../../../../../densityratioplots/',num2str(i-1),'.tiff');

    print(h,'-dtiffn',filename,'-r50')
    
    close all
end
clear variables;
clc;
close all;

names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6','Pos10exp1',...
    'Pos5exp4','Pos6exp3','Pos7exp4','Pos6exp4','Pos9exp2','Pos9exp3',...
    'Pos9exp1','Pos6','Pos7','Pos1exp2','Pos2exp1','Pos0'};
initialarea = flipud([2.56514721 ; 2.14046358 ; 1.73434272 ; 1.48820668 ; ...
    1.11914679 ; 0.8574703 ; 0.680720558 ; 0.636105372 ; 0.596106663 ; ...
    0.543646694 ; 0.448605372 ; 0.357986829 ; 0.300684401; 0.259265238 ; ...
    0.242155217 ; 0.234988378 ; 0.234762397 ; 0.144757231]);

LN = length(names);

total_n = 10000*ones(LN,1);
total_n(10) = 11564;
total_n(13) = 11485;

countsets = zeros(LN,1);
percentsets = zeros(LN,1);

for i = 1:length(names)
    load(strcat('emceeinit_10000samples_',names{i},'.mat'))
    
    countsets(i) = count_numparametersets;
    
    percentsets(i) = total_n(i)/countsets(i);
end

plot(initialarea,percentsets,'o--','Color','k','LineWidth',2,'MarkerFaceColor','k')
xlabel('Initial Area (mm$^2$)','Interpreter','latex','FontSize',22)
ylabel('Percent of Parameter Sets Accepted','Interpreter','latex','FontSize',22)

set(gca,'FontSize',18,'XScale','log','Position',[0.14 0.14 0.82 0.82])
xlim([0.1,4])
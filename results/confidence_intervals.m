clear variables;
clc;

names = {'Pos11exp1','Pos14exp7','Pos14exp2','Pos10exp3','Pos14exp6','Pos10exp1',...
    'Pos5exp4','Pos6exp3','Pos7exp4','Pos6exp4','Pos9exp2','Pos9exp3',...
    'Pos9exp1','Pos6','Pos7','Pos1exp2','Pos2exp1','Pos0'};

LN = length(names);

total_n = 10000;
percent_holdon = 1;%0.2;
n = percent_holdon * total_n;

xbar = zeros(LN,4);
s = zeros(LN,4);

tstar = tinv((1+0.95)/2 , n-1);

CIlower = zeros(LN,4);
CIupper = zeros(LN,4);

Fk = zeros(n,LN);
kb = zeros(n,LN);
alpha = zeros(n,LN);
rho0 = zeros(n,LN);

for i = 1:length(names)
    load(strcat('emceeinit_10000samples_',names{i},'.mat'))
    
    [sortedValues,sortIndex] = sort(minquant); %%% sort minquant vector
    minIndex = sortIndex(1:n); %%% hold on to indices of smallest n errors
    
    m = paramval'; %%% hold on to parameter values corresponding with smallest n errors
    Fk(:,i) = m(minIndex,1);
    kb(:,i) = m(minIndex,2);
    alpha(:,i) = m(minIndex,3);
    rho0(:,i) = m(minIndex,4);
    
    for j = 1:4
        xbar(i,j) = mean(m(:,j));
        s(i,j) = std(m(:,j));
        
        CIlower(i,j) = xbar(i,j) - tstar * s(i,j)/sqrt(n);
        CIupper(i,j) = xbar(i,j) + tstar * s(i,j)/sqrt(n);
    end
end
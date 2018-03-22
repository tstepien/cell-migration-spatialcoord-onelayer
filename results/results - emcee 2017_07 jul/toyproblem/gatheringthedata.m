L=115;
frameIncrement=5;

for i = 1:L
    exp_densratios{i} = density{i}./density{i+frameIncrement};
    exp_densratios{i}(isnan(exp_densratios{i})==1) = 0; %remove 0 divided by 0
    exp_densratios{i}(isinf(exp_densratios{i})==1) = 0; %remove divide by 0
end

global g

for i=1:120
    exp_boundaries{i}=curve{i}+g.xmax;
end
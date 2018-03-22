function [pos,dens] = movies_density(g,Phi,density,bdy)

mid = ceil(length(g.y)/2);

% bdyL =  g.x(ind(1)) - Phi(mid,ind(1))/(Phi(mid,ind(1))-Phi(mid,ind(1)-1))*g.dx;
% bdyR = g.x(ind(end)) + -Phi(mid,ind(end))/(Phi(mid,ind(end)+1)-Phi(mid,ind(end)))*g.dx;
% 
% ind_ext = [bdyL ind bdyR];
% 
% xall = g.x(ind_ext)';
% Call = [bdy , density(mid,ind) , bdy];




pos = [];
dens = [];
for i = 1:length(g.x)-1
    if Phi(mid,i)<0 && Phi(mid,i+1)>0
        pos = [pos , g.x(i+1) - Phi(mid,i+1)/(Phi(mid,i+1)-Phi(mid,i))*g.dx];
        dens = [dens , bdy];
    elseif Phi(mid,i)>0 && Phi(mid,i+1)>0
        pos = [pos , g.x(i)];
        dens = [dens , density(mid,i)];
    elseif Phi(mid,i)>0 && Phi(mid,i+1)<0
        pos = [pos , g.x(i) + -Phi(mid,i)/(Phi(mid,i+1)-Phi(mid,i))*g.dx];
        dens = [dens , bdy];
    end
end
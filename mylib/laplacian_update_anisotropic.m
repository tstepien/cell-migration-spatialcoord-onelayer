function [A,b_add,rhs] = laplacian_update_anisotropic(KB,lapl,Phi,Dt,rhs)
% [A,b_add,rhs] = laplacian_update_anisotropic(KB,lapl,Phi,Dt,rhs)
%
% A matrix representing the Laplace operator based on the level set.  It is
% updated from the original Laplace operator using interpolating
% polynomials and including only those rows associated with boundary
% conditions.  Adds additional tolerance that force the "fingering" case
% (case 3) to assign Axx=0.  Allows for nonuniform anisotropic diffusion.
%
% inputs:
%   D    = diffusion matrices (structure with x- and y- directions)
%   lapl = structure of Laplacians {Lxx,Lyy}
%   Phi  = level set
%   Dt   = sparse matrix of time step
%   rhs  = the right hand side
%
% outputs:
%   A     = updated Laplacian (note that Axx is the Laplacian for
%           x-direction, Ayy is the Laplacian for y-direction)
%   b_add = additional RHS terms due to boundary
%   rhs   = the updated right hand side

global g init_cond;

nx = g.Nx; %%% number of intervals in the x-direction
ny = g.Ny; %%% number of intervals in the y-direction
dx = g.dx; %%% grid spacing in the x-direction
dy = g.dy; %%% grid spacing in the y-direction

Lxx = lapl.Lxx;
Lyy = lapl.Lyy;

Dx = KB.x;
Dy = KB.y;
bdy = init_cond.bdy;

TOL_r = 0.3; %%% how large of a region surrounding the boundary
newTOL = 1;
bx = sparse((nx+1)*(ny+1),1);
by = sparse((nx+1)*(ny+1),1);

%%%---------------------------- x-direction ----------------------------%%%

%%% Identify the cases in which it is necessary to adapt the x-derivatives
%%% near the interface and assign marks
Phi_ge0 = Phi(2:ny,2:nx) >=0;
Phi_im1_ge0 = Phi(2:ny,1:nx-1) >=0;
Phi_ip1_ge0 = Phi(2:ny,3:nx+1) >=0;

%%% case 1
[ind1_case1,ind2_case1] = find(Phi_ge0 & ~Phi_im1_ge0 & Phi_ip1_ge0);
ind1_case1 = ind1_case1+1;
ind2_case1 = ind2_case1+1;

%%% case 2
[ind1_case2,ind2_case2] = find(Phi_ge0 & Phi_im1_ge0 & ~Phi_ip1_ge0);
ind1_case2 = ind1_case2+1;
ind2_case2 = ind2_case2+1;

%%% case 3
[ind1_case3,ind2_case3] = find(Phi_ge0 & ~Phi_im1_ge0 & ~Phi_ip1_ge0);
ind1_case3 = ind1_case3+1;
ind2_case3 = ind2_case3+1;

index1 = [ind1_case1; ind1_case2; ind1_case3];
index2 = [ind2_case1; ind2_case2; ind2_case3];

%%% Set equal to zero nodes near boundary
temp_inds = (nx+1)*(index1-1)+index2;
temp_ones = ones(size(Lxx,1),1);
temp_ones(temp_inds) = 0;
M = spdiags(temp_ones,0,size(Lxx,1),size(Lxx,2));
Axx = M*Lxx;
sizeAxx = size(Axx);

%%% case 1:
%%% node(i-1,j) -- interface -- node(i,j) -- node(i+1,j)
inds = sub2ind(size(Phi),ind1_case1,ind2_case1);
inds_m1 = sub2ind(size(Phi),ind1_case1,ind2_case1-1);
inds_p1 = sub2ind(size(Phi),ind1_case1,ind2_case1+1);
inds_p2 = sub2ind(size(Phi),ind1_case1,ind2_case1+2);

rx = Phi(inds)./(Phi(inds) - Phi(inds_m1));

Dxint = -(Dx(inds)-Dx(inds_m1)).*rx + Dx(inds);

r_small = rx<TOL_r;
rx_temp = rx(r_small);
if numel(rx_temp) > 0
    Dxint_temp = Dxint(r_small);
    Dx_p1 = Dx(inds_p1(r_small));
    Dx_p2 = Dx(inds_p2(r_small));
    
    indsx_p1 = sub2ind(sizeAxx,...
                  (nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small),...
                  (nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small)+1);
    indsx_p2 = sub2ind(sizeAxx,...
                  (nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small),...
                  (nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small)+2);

    T1 = 3.*Dxint_temp./(1+rx_temp)./(2+rx_temp) - (2-rx_temp).*Dx_p1./(1+rx_temp) ...
         + (1-rx_temp).*Dx_p2./(2+rx_temp);
    T2 = 2.*Dxint_temp./(1+rx_temp)./(2+rx_temp) + 2.*rx_temp.*Dx_p1./(1+rx_temp) ...
         - rx_temp.*Dx_p2./(2+rx_temp);
    
    Axx(indsx_p1) = T1.*( -(2-rx_temp)./(1+rx_temp)./dx^2 ) ...
                        + T2.*( -2./(1+rx_temp)./dx^2 );
    Axx(indsx_p2) = T1.*( (1-rx_temp)./(2+rx_temp)./dx^2 ) ...
                        + T2.*( 2./(2+rx_temp)./dx^2 );
    bx((nx+1).*(ind1_case1(r_small)-1)+ind2_case1(r_small)) = ...
                        T1.*(3.*bdy./(1+rx_temp)./(2+rx_temp)./dx^2) ...
                        + T2.*(2.*bdy./(1+rx_temp)./(2+rx_temp)./dx^2);
end

rx_temp = rx(~r_small);
if numel(rx_temp) > 0
    Dxint_temp = Dxint(~r_small);
    Dx_0 = Dx(inds(~r_small));
    Dx_p1 = Dx(inds_p1(~r_small));
    
    indsx_p1 = sub2ind(sizeAxx,...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small),...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small)+1);
    indsx = sub2ind(sizeAxx,...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small),...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small));
    
    T1 = Dxint_temp./rx_temp./(1+rx_temp) - (1-rx_temp).*Dx_0./rx_temp ...
         - rx_temp.*Dx_p1./(1+rx_temp);
    T2 = Dx_0;
    
    Axx(indsx) = T1.*(-(1-rx_temp)./rx_temp./dx^2) ...
                        + T2.*(-2./rx_temp./dx^2);
    Axx(indsx_p1) = T1.*(-rx_temp./(1+rx_temp)./dx^2) ...
                        + T2.*(2./(1+rx_temp)./dx^2);
    bx((nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small)) = ...
                        T1.*(bdy./rx_temp./(1+rx_temp)./dx^2) ...
                        + T2.*(bdy.*2./rx_temp./(1+rx_temp)./dx^2);
end

%%% case 2:
%%% node(i-1,j) -- node(i,j) -- interface -- node(i+1,j)
inds = sub2ind(size(Phi),ind1_case2,ind2_case2);
inds_p1 = sub2ind(size(Phi),ind1_case2,ind2_case2+1);
inds_p2 = sub2ind(size(Phi),ind1_case2,ind2_case2+2);

rx = - Phi(inds)./(Phi(inds_p1) - Phi(inds));

Dxint = (Dx(inds_p1)-Dx(inds)).*rx + Dx(inds);

r_small = rx<TOL_r;
rx_temp = rx(r_small);
if numel(rx_temp) > 0
    Dxint_temp = Dxint(r_small);
    Dx_p1 = Dx(inds_p1(r_small));
    Dx_p2 = Dx(inds_p2(r_small));
    
    indsx_m2 = sub2ind(sizeAxx,...
                  (nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small),...
                  (nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small)-2);
    indsx_m1 = sub2ind(sizeAxx,...
                  (nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small),...
                  (nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small)-1);

    T1 = 3.*Dxint_temp./(1+rx_temp)./(2+rx_temp) - (2-rx_temp).*Dx_p1./(1+rx_temp) ...
         + (1-rx_temp).*Dx_p2./(2+rx_temp);
    T2 = 2.*Dxint_temp./(1+rx_temp)./(2+rx_temp) + 2.*rx_temp.*Dx_p1./(1+rx_temp) ...
         - rx_temp.*Dx_p2./(2+rx_temp);
    
    Axx(indsx_m2) = T1.*((1-rx_temp)./(2+rx_temp)./dx^2 ) ...
                        + T2.*( 2./(2+rx_temp)./dx^2);
    Axx(indsx_m1) = T1.*( -(2-rx_temp)./(1+rx_temp)./dx^2 ) ...
                        + T2.*( -2./(1+rx_temp)./dx^2);
    bx((nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small)) = ...
                        T1.*(3.*bdy./(1+rx_temp)./(2+rx_temp)./dx^2)...
                        + T2.*(2.*bdy./(1+rx_temp)./(2+rx_temp)./dx^2);
end

rx_temp = rx(~r_small);
if numel(rx_temp) > 0
    Dxint_temp = Dxint(~r_small);
    Dx_0 = Dx(inds(~r_small));
    Dx_p1 = Dx(inds_p1(~r_small));
    
    indsx_m1 = sub2ind(sizeAxx,...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small),...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small)-1);
    indsx = sub2ind(sizeAxx,...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small),...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small));
    
    T1 = Dxint_temp./rx_temp./(1+rx_temp) - (1-rx_temp).*Dx_0./rx_temp ...
         - rx_temp.*Dx_p1./(1+rx_temp);
    T2 = Dx_0;
    
    Axx(indsx_m1) = T1.*(-rx_temp./(1+rx_temp)./dx^2) ...
                        + T2.*(2./(1+rx_temp)./dx^2);
    Axx(indsx) = T1.*(-(1-rx_temp)./rx_temp./dx^2) ...
                        + T2.*(-2./rx_temp./dx^2);
    bx((nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small)) = ...
                        T1.*(bdy./rx_temp./(1+rx_temp)./dx^2) ...
                        + T2.*(bdy.*2./rx_temp./(1+rx_temp)./dx^2);
end

%%% case 3:
%%% node(i-1,j) -- interface -- node(i,j) -- interface -- node(i+1,j)
inds = sub2ind(size(Phi),ind1_case3,ind2_case3);
inds_m1 = sub2ind(size(Phi),ind1_case3,ind2_case3-1);
inds_p1 = sub2ind(size(Phi),ind1_case3,ind2_case3+1);

rx1 = Phi(inds)./(Phi(inds) - Phi(inds_m1));
rx2 = -Phi(inds)./(Phi(inds_p1) - Phi(inds));

Dxint1 = -(Dx(inds)-Dx(inds_m1)).*rx1 + Dx(inds);
Dxint2 = (Dx(inds_p1)-Dx(inds)).*rx2 + Dx(inds);

r1_small = rx1<newTOL;
r2_small = rx2<newTOL;
not_r_small = ~r1_small & ~r2_small;
rx_temp1 = rx1(not_r_small);
rx_temp2 = rx2(not_r_small);
if numel(rx_temp1) > 0
    Dxint1_temp = Dxint1(not_r_small);
    Dxint2_temp = Dxint2(not_r_small);
    Dx_0 = Dx(inds(not_r_small));
    
    indsx = sub2ind(sizeAxx,...
          (nx+1).*(ind1_case3(not_r_small)-1) + ind2_case3(not_r_small),...
          (nx+1).*(ind1_case3(not_r_small)-1) + ind2_case3(not_r_small)-2);

    T1 = rx_temp2.*Dxint1_temp./rx_temp1./(rx_temp1+rx_temp2) ...
         - (rx_temp2-rx_temp1).*Dx_0./rx_temp1./rx_temp2 ...
         - rx_temp1.*Dxint2_temp./(rx_temp1+rx_temp2)./rx_temp2;
    T2 = Dx_0;
    
    Axx(indsx) = T1.*( -(rx_temp2-rx_temp1)./rx_temp1./rx_temp2./dx^2 ) ...
                     + T2.*( 2./rx_temp1./rx_temp2./dx^2 );
    bx((nx+1).*(ind1_case3(not_r_small)-1) + ind2_case3(not_r_small)) = ...
               T1.*(bdy.*rx_temp2./rx_temp1./(rx_temp1+rx_temp2)./dx^2 ...
               - bdy.*rx_temp1./rx_temp2./(rx_temp1+rx_temp2)./dx^2 ) ...
               + T2.*(bdy.*2./rx_temp1./(rx_temp1+rx_temp2)./dx^2 ...
               + bdy.*2./rx_temp2./(rx_temp1+rx_temp2)./dx^2 );
end

%%%---------------------------- y-direction ----------------------------%%%
clear index1 index2 temp_inds temp_ones M

%%% Identify the cases in which it is necessary to adapt the y-derivatives
%%% near the interface and assign marks
Phi_ge0 = Phi(2:ny,2:nx) >=0;
Phi_jm1_ge0 = Phi(1:ny-1,2:nx) >=0;
Phi_jp1_ge0 = Phi(3:ny+1,2:nx) >=0;
  
%%% case 1
[ind1_case1,ind2_case1] = find(Phi_ge0 & (~Phi_jm1_ge0) & Phi_jp1_ge0);
ind1_case1 = ind1_case1+1;
ind2_case1 = ind2_case1+1;

%%% case 2
[ind1_case2,ind2_case2] = find(Phi_ge0 & Phi_jm1_ge0 & (~Phi_jp1_ge0));
ind1_case2 = ind1_case2+1;
ind2_case2 = ind2_case2+1;

%%% case 3
[ind1_case3,ind2_case3] = find(Phi_ge0 & (~Phi_jm1_ge0) & (~Phi_jp1_ge0));
ind1_case3 = ind1_case3+1;
ind2_case3 = ind2_case3+1;

index1 = [ind1_case1; ind1_case2; ind1_case3];
index2 = [ind2_case1; ind2_case2; ind2_case3];

%%% Set equal to zero nodes near boundary
temp_inds = (ny+1)*(index1-1)+index2;
temp_ones = ones(size(Lyy,1),1);
temp_ones(temp_inds) = 0;
M = spdiags(temp_ones,0,size(Lyy,1),size(Lyy,2));
Ayy = M*Lyy;
sizeAyy = size(Ayy);

%%% case 1:
%%% node(i-1,j) -- interface -- node(i,j) -- node(i+1,j)
inds = sub2ind(size(Phi),ind1_case1,ind2_case1);
inds_m1 = sub2ind(size(Phi),ind1_case1-1,ind2_case1);
inds_p1 = sub2ind(size(Phi),ind1_case1+1,ind2_case1);
inds_p2 = sub2ind(size(Phi),ind1_case1+2,ind2_case1);

ry = Phi(inds)./(Phi(inds) - Phi(inds_m1));

Dyint = -(Dy(inds)-Dy(inds_m1)).*ry + Dy(inds);

r_small = ry<TOL_r;
ry_temp = ry(r_small);
if numel(ry_temp) > 0
    Dyint_temp = Dyint(r_small);
    Dy_p1 = Dy(inds_p1(r_small));
    Dy_p2 = Dy(inds_p2(r_small));
    
    indsy_p1 = sub2ind(sizeAyy,...
                  (nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small),...
                  (nx+1).*(ind1_case1(r_small)) + ind2_case1(r_small));
    indsy_p2 = sub2ind(sizeAyy,...
                  (nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small),...
                  (nx+1).*(ind1_case1(r_small)+1) + ind2_case1(r_small));

    T1 = 3.*Dyint_temp./(1+ry_temp)./(2+ry_temp) - (2-ry_temp).*Dy_p1./(1+ry_temp) ...
         + (1-ry_temp).*Dy_p2./(2+ry_temp);
    T2 = 2.*Dyint_temp./(1+ry_temp)./(2+ry_temp) + 2.*ry_temp.*Dy_p1./(1+ry_temp) ...
         - ry_temp.*Dy_p2./(2+ry_temp);
    
    Ayy(indsy_p1) = T1.*(-(2-ry_temp)./(1+ry_temp)./dy^2) ...
                        + T2.*(-2./(1+ry_temp)./dy^2);
    Ayy(indsy_p2) = T1.*((1-ry_temp)./(2+ry_temp)./dy^2) ...
                        + T2.*(2./(2+ry_temp)./dy^2);
    by((nx+1).*(ind1_case1(r_small)-1) + ind2_case1(r_small)) = ...
                        T1.*(3.*bdy./(1+ry_temp)./(2+ry_temp)./dy^2) ...
                        + T2.*(2.*bdy./(1+ry_temp)./(2+ry_temp)./dy^2);
end

ry_temp = ry(~r_small);
if numel(ry_temp) > 0
    Dyint_temp = Dyint(~r_small);
    Dy_0 = Dy(inds(~r_small));
    Dy_p1 = Dy(inds_p1(~r_small));
    
    indsy = sub2ind(sizeAyy,...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small),...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small));
    indsy_p1 = sub2ind(sizeAyy,...
                (nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small),...
                (nx+1).*(ind1_case1(~r_small)) + ind2_case1(~r_small));

    T1 = Dyint_temp./ry_temp./(1+ry_temp) - (1-ry_temp).*Dy_0./ry_temp ...
         - ry_temp.*Dy_p1./(1+ry_temp);
    T2 = Dy_0;
    
    Ayy(indsy) = T1.*(-(1-ry_temp)./ry_temp./dy^2) ...
                        + T2.*(-2./ry_temp./dy^2);
    Ayy(indsy_p1) = T1.*(-ry_temp./(1+ry_temp)./dy^2) ...
                        + T2.*(2./(1+ry_temp)./dy^2);
    by((nx+1).*(ind1_case1(~r_small)-1) + ind2_case1(~r_small)) = ...
                        T1.*(bdy./ry_temp./(1+ry_temp)./dy^2) ...
                        + T2.*(bdy.*2./ry_temp./(1+ry_temp)./dy^2);
end
                
%%% case 2:
%%% node(i-1,j) -- node(i,j) -- interface -- node(i+1,j)
inds = sub2ind(size(Phi),ind1_case2,ind2_case2);
inds_p1 = sub2ind(size(Phi),ind1_case2+1,ind2_case2);
inds_p2 = sub2ind(size(Phi),ind1_case2+2,ind2_case2);

ry = - Phi(inds)./(Phi(inds_p1) - Phi(inds));

Dyint = (Dy(inds_p1)-Dy(inds)).*ry + Dy(inds);

r_small = ry<TOL_r;
ry_temp = ry(r_small);
if numel(ry_temp) > 0
    Dyint_temp = Dyint(r_small);
    Dy_p1 = Dy(inds_p1(r_small));
    Dy_p2 = Dy(inds_p2(r_small));
    
    indsy_m1 = sub2ind(sizeAyy,...
                  (nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small),...
                  (nx+1).*(ind1_case2(r_small)-2) + ind2_case2(r_small));

    indsy_m2 = sub2ind(sizeAyy,...
                  (nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small),...
                  (nx+1).*(ind1_case2(r_small)-3)+ind2_case2(r_small));

    T1 = 3.*Dyint_temp./(1+ry_temp)./(2+ry_temp) - (2-ry_temp).*Dy_p1./(1+ry_temp) ...
         + (1-ry_temp).*Dy_p2./(2+ry_temp);
    T2 = 2.*Dyint_temp./(1+ry_temp)./(2+ry_temp) + 2.*ry_temp.*Dy_p1./(1+ry_temp) ...
         - ry_temp.*Dy_p2./(2+ry_temp);
    
    Ayy(indsy_m2) = T1.*((1-ry_temp)./(2+ry_temp)./dy^2 ) ...
                        + T2.*( 2./(2+ry_temp)./dy^2);
    Ayy(indsy_m1) = T1.*( -(2-ry_temp)./(1+ry_temp)./dy^2 ) ...
                        + T2.*( -2./(1+ry_temp)./dy^2);
    by((nx+1).*(ind1_case2(r_small)-1) + ind2_case2(r_small)) = ...
                        T1.*( 3.*bdy./(1+ry_temp)./(2+ry_temp)./dy^2 ) ...
                        + T2.*( 2.*bdy./(1+ry_temp)./(2+ry_temp)./dy^2 );
end

ry_temp = ry(~r_small);
if numel(ry_temp) > 0
    Dyint_temp = Dyint(~r_small);
    Dy_0 = Dy(inds(~r_small));
    Dy_p1 = Dy(inds_p1(~r_small));
    
    indsy = sub2ind(sizeAyy,...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small),...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small));
    indsy_m1 = sub2ind(sizeAyy,...
                (nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small),...
                (nx+1).*(ind1_case2(~r_small)-2) + ind2_case2(~r_small));
        
    T1 = Dyint_temp./ry_temp./(1+ry_temp) - (1-ry_temp).*Dy_0./ry_temp ...
         - ry_temp.*Dy_p1./(1+ry_temp);
    T2 = Dy_0;
    
    Ayy(indsy_m1) = T1.*(-ry_temp./(1+ry_temp)./dy^2) ...
                        + T2.*(2./(1+ry_temp)./dy^2);
    Ayy(indsy) = T1.*(-(1-ry_temp)./ry_temp./dy^2) ...
                        + T2.*(-2./ry_temp./dy^2);
    by((nx+1).*(ind1_case2(~r_small)-1) + ind2_case2(~r_small)) = ...
                        T1.*(bdy./ry_temp./(1+ry_temp)./dy^2) ...
                        + T2.*(bdy.*2./ry_temp./(1+ry_temp)./dy^2);
end
                                
%%% case 3:
%%% node(i-1,j) -- interface -- node(i,j) -- interface -- node(i+1,j)
inds = sub2ind(size(Phi),ind1_case3,ind2_case3);
inds_m1 = sub2ind(size(Phi),ind1_case3-1,ind2_case3);
inds_p1 = sub2ind(size(Phi),ind1_case3+1,ind2_case3);

ry1 = Phi(inds)./(Phi(inds) - Phi(inds_m1));
ry2 = -Phi(inds)./(Phi(inds_p1) - Phi(inds));

Dyint1 = -(Dy(inds)-Dy(inds_m1)).*ry1 + Dy(inds);
Dyint2 = (Dy(inds_p1)-Dy(inds)).*ry2 + Dy(inds);

r1_small = ry1<newTOL;
r2_small = ry2<newTOL;
not_r_small = ~r1_small & ~r2_small;
ry_temp1 = ry1(not_r_small);
ry_temp2 = ry2(not_r_small);
if numel(ry_temp1) > 0
    Dyint1_temp = Dyint1(not_r_small);
    Dyint2_temp = Dyint2(not_r_small);
    Dy_0 = Dy(inds(not_r_small));
    
    indsy = sub2ind(sizeAyy,...
          (nx+1).*(ind1_case3(not_r_small)-1) + ind2_case3(not_r_small),...
          (nx+1).*(ind1_case3(not_r_small)-1) + ind2_case3(not_r_small));

    T1 = ry_temp2.*Dyint1_temp./ry_temp1./(ry_temp1+ry_temp2) ...
         - (ry_temp2-ry_temp1).*Dy_0./ry_temp1./ry_temp2 ...
         - ry_temp1.*Dyint2_temp./(ry_temp1+ry_temp2)./ry_temp2;
    T2 = Dy_0;
    
    Ayy(indsy) = T1.*(-(ry_temp2-ry_temp1)./ry_temp1./ry_temp2./dy^2) ...
                     + T2.*(2./ry_temp1./ry_temp2./dy^2);
    by((nx+1).*(ind1_case3(not_r_small)-1) + ind2_case3(not_r_small)) = ...
               T1.*(bdy.*ry_temp2./ry_temp1./(ry_temp1+ry_temp2)./dy^2 ...
               - bdy.*ry_temp1./ry_temp2./(ry_temp1+ry_temp2)./dy^2 ) ...
               + T2.*(bdy.*2./ry_temp1./(ry_temp1+ry_temp2)./dy^2 ...
               + bdy.*2./ry_temp2./(ry_temp1+ry_temp2)./dy^2 );
end

%%%------------------------ for both directions ------------------------%%%
b_add = Dt*(bx + by);

A = speye((nx+1)*(ny+1),(nx+1)*(ny+1)) - Dt*(Axx + Ayy);

for j = 1:ny+1
    for i = 1:nx+1
        if abs(Phi(j,i)) < 1e-12
            A((nx+1)*(j-1)+i,:) = sparse(1,(nx+1)*(ny+1));
            A((nx+1)*(j-1)+i,(nx+1)*(j-1)+i) = 1;
            rhs((nx+1)*(j-1)+i) = bdy;
            b_add((nx+1)*(j-1)+i) = 0;
        end
    end
end
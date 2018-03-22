function [DxL,DxR,DyL,DyR] = levelset_WENO2D(Phi,g)
% [DxL,DxR,DyL,DyR] = levelset_WENO2D(Phi)
%
% approximate space derivatives of the level set
%
% input:
%   Phi = level set
%
% outputs:
%   DxL = 
%   DxR = 
%   DyL = 
%   DyR = 

nx = g.Nx+1; %%% number of nodes in the x-direction
ny = g.Ny+1; %%% number of nodes in the x-direction
dx = g.dx; %%% grid spacing in the x-direction
dy = g.dy; %%% grid spacing in the y-direction

eps = 1e-6;

Phi_e = levelset_extension(Phi,g);

%%%----------- computing the derivatives in the x-direction -----------%%%
Dpx = diff(Phi_e(4:ny+3,:)/dx,1,2);
Dpxx = diff(Dpx,1,2);
Dpxxx = diff(Dpxx,1,2);
Dpxxxx = diff(Dpxxx,1,2);

Mx = (-Phi_e(4:ny+3,6:nx+5) + 8*Phi_e(4:ny+3,5:nx+4) ...
      - 8*Phi_e(4:ny+3,3:nx+2) + Phi_e(4:ny+3,2:nx+1))/(12*dx);

IS0 = 13*Dpxxx(:,1:end-3).^2 + 3*(Dpxx(:,1:end-4)-3*Dpxx(:,2:end-3)).^2;
IS1 = 13*Dpxxx(:,2:end-2).^2 + 3*(Dpxx(:,2:end-3)+Dpxx(:,3:end-2)).^2;
IS2 = 13*Dpxxx(:,3:end-1).^2 + 3*(3*Dpxx(:,3:end-2)-Dpxx(:,4:end-1)).^2;

alp0 = 1./(eps + IS0).^2;
alp1 = 6./(eps + IS1).^2;
alp2 = 3./(eps + IS2).^2;

w0 = alp0./(alp0 + alp1 + alp2);
w2 = alp2./(alp0 + alp1 + alp2);

DxL = Mx - (1/3*w0.*Dpxxxx(:,1:end-2) + 1/6*(w2-0.5).*Dpxxxx(:,2:end-1));

IS0 = 13*Dpxxx(:,4:end).^2 + 3*(Dpxx(:,5:end)-3*Dpxx(:,4:end-1)).^2;
IS1 = 13*Dpxxx(:,3:end-1).^2 + 3*(Dpxx(:,4:end-1)+Dpxx(:,3:end-2)).^2;
IS2 = 13*Dpxxx(:,2:end-2).^2 + 3*(3*Dpxx(:,3:end-2)-Dpxx(:,2:end-3)).^2;

alp0 = 1./(eps + IS0).^2;
alp1 = 6./(eps + IS1).^2;
alp2 = 3./(eps + IS2).^2;

w0 = alp0./(alp0 + alp1 + alp2);
w2 = alp2./(alp0 + alp1 + alp2);

DxR = Mx + (1/3*w0.*Dpxxxx(:,3:end) + 1/6.*(w2-0.5).*Dpxxxx(:,2:end-1));


%%%----------- computing the derivatives in the y-direction -----------%%%
Dpy = diff(Phi_e(:,4:nx+3)/dy);
Dpyy = diff(Dpy);
Dpyyy = diff(Dpyy);
Dpyyyy = diff(Dpyyy);

My = (-Phi_e(6:ny+5,4:nx+3) + 8*Phi_e(5:ny+4,4:nx+3) ...
      - 8*Phi_e(3:ny+2,4:nx+3) + Phi_e(2:ny+1,4:nx+3))/(12*dy);

IS0 = 13*Dpyyy(1:end-3,:).^2 + 3*(Dpyy(1:end-4,:)-3*Dpyy(2:end-3,:)).^2;
IS1 = 13*Dpyyy(2:end-2,:).^2 + 3*(Dpyy(2:end-3,:)+Dpyy(3:end-2,:)).^2;
IS2 = 13*Dpyyy(3:end-1,:).^2 + 3*(3*Dpyy(3:end-2,:)-Dpyy(4:end-1,:)).^2;

alp0 = 1./(eps + IS0).^2;
alp1 = 6./(eps + IS1).^2;
alp2 = 3./(eps + IS2).^2;

w0 = alp0./(alp0 + alp1 + alp2);
w2 = alp2./(alp0 + alp1 + alp2);

DyL = My - (1/3*w0.*Dpyyyy(1:end-2,:) + 1/6*(w2-0.5).*Dpyyyy(2:end-1,:));

IS0 = 13*Dpyyy(4:end,:).^2 + 3*(Dpyy(5:end,:)-3*Dpyy(4:end-1,:)).^2;
IS1 = 13*Dpyyy(3:end-1,:).^2 + 3*(Dpyy(4:end-1,:)+Dpyy(3:end-2,:)).^2;
IS2 = 13*Dpyyy(2:end-2,:).^2 + 3*(3*Dpyy(3:end-2,:)-Dpyy(2:end-3,:)).^2;

alp0 = 1./(eps + IS0).^2;
alp1 = 6./(eps + IS1).^2;
alp2 = 3./(eps + IS2).^2;

w0 = alp0./(alp0 + alp1 + alp2);
w2 = alp2./(alp0 + alp1 + alp2);

DyR = My + (1/3*w0.*Dpyyyy(3:end,:) + 1/6.*(w2-0.5).*Dpyyyy(2:end-1,:));
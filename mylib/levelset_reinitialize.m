function Phi_new = levelset_reinitialize(Phi,dtau,order)
% Phi_new = levelset_reinitialize(Phi,dtau,order)
%
% Reinitializes level set in 2D using a fast, lower order WENO algorithm
%
% inputs:
%   Phi   = old level set
%   dtau  = time step for reinitializing
%   order =
%
% output:
%   Phi_new = new level set

global g reinit error;

dx = g.dx; %%% grid spacing in the x-direction
dy = g.dy; %%% grid spacing in the y-direction

reinit_band = reinit.band;
reinit_ITERMAX = reinit.ITERMAX;
reinit_TOL = reinit.TOL;

eps = 1e-10;
eps2 = 2*dx;

flag = 1; %%% true
region = reinit_band * dx;
iter = 0;
Phi_old = Phi;
S = Phi./sqrt(Phi.^2 + eps2^2);

while flag && iter < reinit_ITERMAX
    pn = Phi_old;
    [DxL,DxR,DyL,DyR] = levelset_WENO2D(pn);

    Gn = (Phi>=eps).*(sqrt(max(max(DxL,0).^2,min(DxR,0).^2) ...
        + max(max(DyL,0).^2,min(DyR,0).^2)) - 1) ...
        + (abs(Phi)<eps).*0 ...
        + (Phi<=-eps).*(sqrt(max(min(DxL,0).^2,max(DxR,0).^2) ...
        + max(min(DyL,0).^2,max(DyR,0).^2)) - 1);

    pn_1 = pn - dtau*S.*Gn;

    if order == 1
        Phi_new = pn_1;
    else
        [DxL,DxR,DyL,DyR] = levelset_WENO2D(pn_1);
        Gn_1 = (Phi>=eps).*(sqrt(max(max(DxL,0).^2,min(DxR,0).^2) ...
            + max(max(DyL,0).^2,min(DyR,0).^2)) - 1) ...
            + (abs(Phi)<eps).*0 ...
            + (Phi<=-eps).*(sqrt(max(min(DxL,0).^2,max(DxR,0).^2) ...
            + max(min(DyL,0).^2,max(DyR,0).^2)) - 1);
        pn_1_2 = pn - dtau/4*S.*(Gn + Gn_1);

        if order == 2
            Phi_new = pn_1_2;
        else
            [DxL,DxR,DyL,DyR] = levelset_WENO2D(pn_1_2);
            Gn_1_2 = (Phi>=eps).*(sqrt(max(max(DxL,0).^2,min(DxR,0).^2) ...
                  + max(max(DyL,0).^2,min(DyR,0).^2)) - 1) ...
                  + (abs(Phi)<eps).*0 ...
                  + (Phi<=-eps).*(sqrt(max(min(DxL,0).^2,max(DxR,0).^2) ...
                  + max(min(DyL,0).^2,max(DyR,0).^2)) - 1);
            Phi_new = pn - dtau/6 * S.*(Gn + 4*Gn_1_2 + Gn_1);
        end
    end
    
    error = max(max((abs(Phi_new) <= region).*(S.*Gn)));

    if error < reinit_TOL
        flag = 0; %%% false
        Phi_new = Phi_old;
    else
        Phi_old = Phi_new;
        iter = iter + 1;
    end
end
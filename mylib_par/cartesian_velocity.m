function [Vx,Vy,Veta,Vzeta,Gs] = cartesian_velocity(param,Phi,C,g,init_cond)
% [Vx,Vy,Veta,Vzeta,Gs] = cartesian_velocity(param,Phi,C)
%
% Computes the velocity of one layer in a region surrounding the boundary
% in the four Cartesian directions.
%
% inputs:
%   param = parameters (structure with F,k,b,rho0)
%   Phi   = level set
%   C     = density
%
% outputs:
%   Vx    = velocity in the x direction
%   Vy    = velocity in the y direction
%   Veta  = velocity in the eta direction
%   Vzeta = velocity in the zeta direction
%   Gs    = gradient of level set in the x, y, eta, and zeta directions

Nx = g.Nx; %%% number of intervals in the x-direction
Ny = g.Ny; %%% number of intervals in the y-direction
dx = g.dx; %%% grid spacing in the x-direction
dy = g.dy; %%% grid spacing in the y-direction

Tol_r = 0.3; %%% how large of a region surrounding the boundary
iter = 5;

clear Vx Vy Veta Vzeta S Px Py Mark;

D = param.kb;
out = init_cond.out;
bdy = init_cond.bdy;

Vx = zeros(Ny+1,Nx+1);
Vy = zeros(Ny+1,Nx+1);
Veta = zeros(Ny+1,Nx+1);
Vzeta = zeros(Ny+1,Nx+1);
Gs = [];

%%%----------------- Velocity field in the x-direction -----------------%%%
Mark = zeros(Ny+1,Nx+1);
Sigma = ones(Ny+1,Nx+1);

%%% find location of boundary
for j = 1:Ny+1
    for i = 1:Nx+1
        if i == 1
            if Phi(j,i)*Phi(j,i+1) <= 0
                Sigma(j,i) = 0;
            end
        elseif i < Nx+1
            if Phi(j,i)*Phi(j,i-1) <= 0 || Phi(j,i)*Phi(j,i+1) <= 0
                Sigma(j,i) = 0;
            end
        else
            if Phi(j,i)*Phi(j,i-1) <= 0
                Sigma(j,i) = 0;
            end
        end
        if i~=1
            if Phi(j,i) > 0 && Phi(j,i-1) == 0
                Sigma(j,i) = 1;
            end
        end
        if i~=Nx+1
            if Phi(j,i) > 0 && Phi(j,i+1) == 0
                Sigma(j,i) = 1;
            end
        end
    end
end

k = 0;
for j = 1:Ny+1
    for i = 1:Nx+1
        if i == 1
            if Phi(j,i) >= 0 && Phi(j,i+1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        elseif i < Nx+1
            if Phi(j,i) >= 0 && Phi(j,i-1) < 0 && Phi(j,i+1) < 0
                Mark(j,i) = 0.5;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            elseif Phi(j,i) >= 0 && (Phi(j,i-1) < 0 || Phi(j,i+1) < 0)
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        else
            if Phi(j,i) >= 0 && Phi(j,i-1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
    end
end

%%% check to make sure cell boundary is not leaving computational domain
bdyondomain = [Mark(1,:)' ; Mark(:,1) ; Mark(Ny+1,:)' ; Mark(:,Nx+1)];
if max(bdyondomain) > 0
    Vx(1,1) = NaN;
    return
end

%%% calculate velocity
if k > 0
    for m = 1:k
        j = index1(m);
        i = index2(m);
        if Mark(j,i) == 1 && i == 1
            r = - Phi(j,i) / (Phi(j,i+1)-Phi(j,i));
            %%% interface very close to index2(m)=1 outer boundary
            Vx(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*dx);
            Vx(j,i+1) = Vx(j,i);
        elseif Mark(j,i) == 1 && i == Nx+1
            r = Phi(j,i) / (Phi(j,i)-Phi(j,i-1));
            %%% interface very close to index2(m)=N+1 outer boundary
            Vx(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*dx);
            Vx(j,i-1) = Vx(j,i);
        elseif Mark(j,i) == 1 && Phi(j,i-1) < 0
            r = Phi(j,i) / (Phi(j,i)-Phi(j,i-1));
            if r <= Tol_r %%% interface very close to index2(m)
                Vx(j,i) = D/(out-bdy)*(C(j,i+1)-bdy)/((1+r)*dx);
                Vx(j,i-1) = Vx(j,i);
            else
                Vx(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*dx);
                Vx(j,i-1) = Vx(j,i);
            end
        elseif Mark(j,i) == 1 && Phi(j,i+1) < 0
            r = - Phi(j,i) / (Phi(j,i+1)-Phi(j,i));
            if r <= Tol_r %%% interface very close to index2(m)
                Vx(j,i) = D/(out-bdy)*(bdy-C(j,i-1))/((1+r)*dx);
                Vx(j,i+1) = Vx(j,i);
            else
                Vx(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*dx);
                Vx(j,i+1) = Vx(j,i);
            end
        elseif Mark(j,i) == 0.5
            r1 = Phi(j,i) / (Phi(j,i)-Phi(j,i-1));
            if r1 == 0
                vel1 = 0;
            else
                vel1 = D/(out-bdy)*(C(j,i)-bdy)/(r1*dx);
            end
            r2 = - Phi(j,i) / (Phi(j,i+1)-Phi(j,i));
            if r2 == 0
                vel2 = 0;
            else
                vel2 = D/(out-bdy)*(bdy-C(j,i))/(r2*dx);
            end
            Vx(j,i-1) = vel1;
            Vx(j,i+1) = vel2;
            if r1 < r2
                Vx(j,i) = vel1;
            else
                Vx(j,i) = vel2;
            end
            if abs(Vx(j,i)) > 10^10
                disp('ERROR in cartesian_velocity -- 1')
                return
            end
        end
        if isnan(Vx(j,i))~=0
            disp('ERROR in cartesian_velocity -- 2')
            return
        end
    end
end

%%% advection: Vx_t + S(P*Px)Vx_x = 0
[Px,Py] = gradient(Phi,dx,dy);
S = sign(Phi.*Px);
dtau = 0.8*dx;

U_old = Vx;
for i = 1:iter
    Uxm = zeros(Ny+1,Nx+1);
    Uxm(:,2:Nx+1) = (U_old(:,2:Nx+1)-U_old(:,1:Nx))/dx;
    Uxm(:,1) = Uxm(:,2);
    Uxp = zeros(Ny+1,Nx+1);
    Uxp(:,1:Nx) = (U_old(:,2:Nx+1)-U_old(:,1:Nx))/dx;
    Uxp(:,Nx+1) = Uxp(:,Nx);

    U_new = U_old - dtau*(max(S.*Sigma,0).*Uxm + min(S.*Sigma,0).*Uxp);
    U_old = U_new;
end
Vx = U_old;

%%%----------------- Velocity field in the y-direction -----------------%%%
Mark = zeros(Ny+1,Nx+1);
Sigma = ones(Ny+1,Nx+1);

%%% find location of boundary
for i = 1:Nx+1
    for j = 1:Ny+1
        if j == 1
            if Phi(j,i)*Phi(j+1,i) <= 0
                Sigma(j,i) = 0;
            end
        elseif j < Ny+1
            if Phi(j,i)*Phi(j-1,i) <= 0 || Phi(j,i)*Phi(j+1,i) <= 0
                Sigma(j,i) = 0;
            end
        else
            if Phi(j,i)*Phi(j-1,i) <= 0
                Sigma(j,i) = 0;
            end
        end
        if j~=1
            if Phi(j,i) > 0 && Phi(j-1,i) == 0
                Sigma(j,i) = 1;
            end
        end
        if j~=Ny+1
            if Phi(j,i) > 0 && Phi(j+1,i) == 0
                Sigma(j,i) = 1;
            end
        end
    end
end

k = 0;
for i = 1:Nx+1
    for j = 1:Ny+1
        if j == 1
            if Phi(j,i) >= 0 && Phi(j+1,i) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        elseif j < Ny+1
            if Phi(j,i) >= 0 && Phi(j-1,i) < 0 && Phi(j+1,i) < 0
                Mark(j,i) = 0.5;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            elseif Phi(j,i) >= 0 && (Phi(j-1,i) < 0 || Phi(j+1,i) < 0)
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        else
            if Phi(j,i) >= 0 && Phi(j-1,i) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
    end
end

%%% check to make sure cell boundary is not leaving computational domain
bdyondomain = [Mark(1,:)' ; Mark(:,1) ; Mark(Ny+1,:)' ; Mark(:,Nx+1)];
if max(bdyondomain) > 0
    Vy(1,1) = NaN;
    return
end

% calculate velocity
if k > 0
    for m = 1:k
        j = index1(m);
        i = index2(m);
        if Mark(j,i) == 1 && j == 1
            r = - Phi(j,i)/(Phi(j+1,i)-Phi(j,i));
            %%% interface very close to index1(m)=1 outer boundary
            Vy(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*dy);
            Vy(j+1,i) = Vy(j,i);
        elseif Mark(j,i) == 1 && j == Ny+1
            r = Phi(j,i) / (Phi(j,i)-Phi(j-1,i));
            %%% interface very close to index1(m)=N+1 outer boundary
            Vy(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*dy);
            Vy(j-1,i) = Vy(j,i);
        elseif Mark(j,i) == 1 && Phi(j-1,i) < 0
            r = Phi(j,i)/(Phi(j,i)-Phi(j-1,i));
            if r <= Tol_r %%% interface very close to index1(m)
                Vy(j,i) = D/(out-bdy)*(C(j+1,i)-bdy)/((1+r)*dy);
                Vy(j-1,i) = Vy(j,i);
            else
                Vy(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*dy);
                Vy(j-1,i) = Vy(j,i);
            end
        elseif Mark(j,i) == 1 && Phi(j+1,i) < 0
            r = - Phi(j,i) / (Phi(j+1,i)-Phi(j,i));
            if r <= Tol_r %%% interface very close to index1(m)
                Vy(j,i) = D/(out-bdy)*(bdy-C(j-1,i))/((1+r)*dy);
                Vy(j+1,i) = Vy(j,i);
            else
                Vy(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*dy);
                Vy(j+1,i) = Vy(j,i);
            end
        elseif Mark(j,i) == 0.5
            r1 = Phi(j,i)/(Phi(j,i)-Phi(j-1,i));
            if r1 == 0
                vel1 = 0;
            else
                vel1 = D/(out-bdy)*(C(j,i)-bdy)/(r1*dy);
            end
            r2 = -Phi(j,i)/(Phi(j+1,i)-Phi(j,i));
            if r2 == 0
                vel2 = 0;
            else
                vel2 = D/(out-bdy)*(bdy-C(j,i))/(r2*dy);
            end
            Vy(j-1,i) = vel1;
            Vy(j+1,i) = vel2;
            if r1 < r2
                Vy(j,i) = vel1;
            else
                Vy(j,i) = vel2;
            end
        end
    end
end

%%% advection: Vy_t + S(P*Py)Vy_y = 0
[Px,Py] = gradient(Phi,dx,dy);
S = sign(Phi.*Py);
dtau = 0.8*dy;

U_old = Vy;
for i = 1:iter
    Uym = zeros(Ny+1,Nx+1);
    Uym(2:Ny+1,:) = (U_old(2:Ny+1,:)-U_old(1:Ny,:))/dy;
    Uym(1,:) = Uym(2,:);
    Uyp = zeros(Ny+1,Nx+1);
    Uyp(1:Ny,:) = (U_old(2:Ny+1,:)-U_old(1:Ny,:))/dy;
    Uyp(Ny+1,:) = Uyp(Ny,:);
    U_new = U_old - dtau*(max(S.*Sigma,0).*Uym + min(S.*Sigma,0).*Uyp);
    U_old = U_new;
end
Vy = U_old;

%%%---------------- Velocity field in the eta-direction ----------------%%%
sqdxdy = sqrt(dx^2+dy^2);

Mark = zeros(Ny+1,Nx+1);
Sigma = ones(Ny+1,Nx+1);

%%% find location of boundary
for j = 1:Ny+1
    for i = 1:Nx+1
        if i == 1 && j~=Ny+1
            if Phi(j,i)*Phi(j+1,i+1) <= 0
                Sigma(j,i) = 0;
            end
        elseif i < Nx+1 && j~=1 && i > 1
            if Phi(j,i)*Phi(j-1,i-1) <= 0
                Sigma(j,i) = 0;
            end
        elseif i < Nx+1 && j~=Ny+1
            if Phi(j,i)*Phi(j+1,i+1) <= 0
                Sigma(j,i) = 0;
            end
        elseif i == Nx+1 && j~=1
            if Phi(j,i)*Phi(j-1,i-1) <= 0
                Sigma(j,i) = 0;
            end
        end
        if i~=Nx+1 && j~=Ny+1
            if Phi(j,i) >0 && Phi(j+1,i+1) == 0
                Sigma(j,i) = 1;
            end
        end
        if i ~=1 && j~=1
            if Phi(j,i) >0 && Phi(j-1,i-1)==0
                Sigma(j,i) = 1;
            end
        end
    end
end

k = 0;
for j = 1:Ny+1
    for i = 1:Nx+1
        if i == 1 && j~=Ny+1
            if Phi(j,i) >= 0 && Phi(j+1,i+1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if i > 1 && i < Nx+1 && j~=1
            if Phi(j,i) >= 0 && Phi(j-1,i-1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if i > 1 && i < Nx+1 && j~=Ny+1
            if Phi(j,i) >= 0 && Phi(j+1,i+1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if i > 1 && i < Nx+1 && j~=1 && j~=Ny+1
            if Phi(j,i) >= 0 && Phi(j-1,i-1) < 0 && Phi(j+1,i+1) < 0
                Mark(j,i) = 0.5;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if i == Nx+1 && j~=1
            if Phi(j,i) >= 0 && Phi(j-1,i-1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
    end
end

%%% check to make sure cell boundary is not leaving computational domain
bdyondomain = [Mark(1,:)' ; Mark(:,1) ; Mark(Ny+1,:)' ; Mark(:,Nx+1)];
if max(bdyondomain) > 0
    Veta(1,1) = NaN;
    return
end

% calculate velocity
if k > 0
    for m = 1:k
        j = index1(m);
        i = index2(m);
        if Mark(j,i) == 1 && i == 1
            r = - Phi(j,i) / (Phi(j+1,i+1)-Phi(j,i));
            %%% interface very close to index2(m)=1 outer boundary
            Veta(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*sqdxdy);
            Veta(j+1,i+1) = Veta(j,i);
        end
        if Mark(j,i) == 1 && i == Nx+1
            r = Phi(j,i) / (Phi(j,i)-Phi(j-1,i-1));
            %%% interface very close to index2(m)=N+1 outher boundary
            Veta(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*sqdxdy);
            Veta(j-1,i-1) = Veta(j,i);
        end
        if Mark(j,i) == 1 && i~=1 && j~=1 && Phi(j-1,i-1) < 0
            r = Phi(j,i) / (Phi(j,i)-Phi(j-1,i-1));
            if r <= Tol_r %%% interface very close to index2(m)
                Veta(j,i) = D/(out-bdy)*(C(j+1,i+1)-bdy)/((1+r)*sqdxdy);
                Veta(j-1,i-1) = Veta(j,i);
            else
                Veta(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*sqdxdy);
                Veta(j-1,i-1) = Veta(j,i);
            end
        end
        if Mark(j,i)==1 && i~=Nx+1 && j~=Nx+1 && j~=1 && i~=1 ...
                && Phi(j+1,i+1) < 0
            r = - Phi(j,i)/(Phi(j+1,i+1)-Phi(j,i));
            if r <= Tol_r  %%% interface very close to index2(m)
                Veta(j,i) = D/(out-bdy)*(bdy-C(j-1,i-1))/...
                    ((1+r)*sqdxdy);
                Veta(j+1,i+1) = Veta(j,i);
            else
                Veta(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*sqdxdy);
                Veta(j+1,i+1) = Veta(j,i);
            end
        end
        if Mark(j,i) == 0.5
            r1 = Phi(j,i) / (Phi(j,i)-Phi(j-1,i-1));
            if r1 == 0
                vel1 = 0;
            else
                vel1 =D/(out-bdy)*(C(j,i)-bdy)/(r1*sqdxdy);
            end
            r2 = - Phi(j,i) / (Phi(j+1,i+1)-Phi(j,i));
            if r2 == 0
                vel2 = 0;
            else
                vel2 =D/(out-bdy)*(bdy-C(j,i))/(r2*sqdxdy);
            end
            Veta(j-1,i-1) = vel1;
            Veta(j+1,i+1) = vel2;
            if r1 < r2
                Veta(j,i) = vel1;
            else
                Veta(j,i) = vel2;
            end
            if abs(Vx(j,i)) > 10^10
                disp('ERROR in cartesian_velocity_4dirs -- 3')
                return
            end
        end
    end
end

%%% gradient of phi in eta direction: GPhi_eta
GPhi_eta = ones(size(Phi));
GPhi_eta(2:end-1,2:end-1) = (Phi(3:end,3:end) - Phi(1:end-2,1:end-2))/...
                            (2*sqdxdy);
GPhi_eta(1:end-1,1) = (Phi(2:end,2)-Phi(1:end-1,1))/sqdxdy;
GPhi_eta(2:end,end) = (Phi(2:end,end)-Phi(1:end-1,end-1))/sqdxdy;
GPhi_eta(end,2:end-1) = (Phi(end,2:end-1)-Phi(end-1,1:end-2))/sqdxdy;
GPhi_eta(1,2:end-1) = (Phi(2,3:end)-Phi(1,2:end-1))/sqdxdy;

GPhi_eta_1_end_x = interp1(g.x(end-2:end-1),GPhi_eta(1,end-2:end-1),...
    g.x(end),'linear','extrap');
GPhi_eta_1_end_y = interp1(g.y(2:3),GPhi_eta(2:3,end),g.y(1),...
    'linear','extrap');
GPhi_eta(1,end) = (GPhi_eta_1_end_x+GPhi_eta_1_end_y)/2;

GPhi_eta_end_1_x = interp1(g.x(2:3),GPhi_eta(end,2:3),g.x(1),...
    'linear','extrap');
GPhi_eta_end_1_y = interp1(g.y(end-2:end-1),GPhi_eta(end-2:end-1,1),...
    g.y(end),'linear','extrap');
GPhi_eta(end,1) = (GPhi_eta_end_1_x+GPhi_eta_end_1_y)/2;

%%% advection of velocity in eta direction
S = sign(Phi.*GPhi_eta);
dtau = 0.8*min(dx,dy);

U_old = Veta;
for i = 1:iter
    Uetam = zeros(Ny+1,Nx+1);
    Uetam(2:end,2:end) = (U_old(2:end,2:end)-U_old(1:end-1,1:end-1))/dx;
    Uetam(1,1:end-1) = Uetam(2,2:end);
    Uetam(1:end-1,1) = Uetam(2:end,2);
    Uetam(end,1) = Uetam(end,2);
    Uetam(1,end) = Uetam(2,end);

    Uetap = zeros(Ny+1,Nx+1);
    Uetap(1:end-1,1:end-1) =(U_old(2:end,2:end)-U_old(1:end-1,1:end-1))/dx;
    Uetap(end,2:end) = Uetap(end-1,1:end-1);
    Uetap(2:end,end) = Uetap(1:end-1,end-1);
    Uetap(end,1) = Uetap(end-1,1);
    Uetap(1,end) = Uetap(1,end-1);

    U_new = U_old - dtau*(max(S.*Sigma,0).*Uetam + min(S.*Sigma,0).*Uetap);
    U_old = U_new;
end

Veta = U_old;

%%%--------------- Velocity field in the zeta-direction ---------------%%%
Mark = zeros(Ny+1,Nx+1);
Sigma = ones(Ny+1,Nx+1);

%%% find location of boundary
for i = 1:Nx+1
    for j = 1:Ny+1
        if j == 1 && i~=1
            if Phi(j,i)*Phi(j+1,i-1) <= 0
                Sigma(j,i) = 0;
            end
        end
        if j < Ny+1 && i ~=1
            if Phi(j,i)*Phi(j+1,i-1) <= 0
                Sigma(j,i) = 0;
            end
        end
        if j < Ny+1 && i~=Nx+1 && j~=1
            if Phi(j,i)*Phi(j-1,i+1) <= 0
                Sigma(j,i) = 0;
            end
        end
        if j==Ny+1 && i~=Nx+1
            if Phi(j,i)*Phi(j-1,i+1) <= 0
                Sigma(j,i) = 0;
            end
        end
        if i~=Nx+1 && j~=1
            if Phi(j,i) >0 && Phi(j-1,i+1) == 0
                Sigma(j,i) = 1;
            end
        end
        if i~=1 && j~=Ny+1
            if Phi(j,i) >0 && Phi(j+1,i-1)==0
                Sigma(j,i) = 1;
            end
        end
    end
end

k = 0;
for i = 1:Nx+1
    for j = 1:Ny+1
        if j == 1 && i~=1
            if Phi(j,i) >= 0 && Phi(j+1,i-1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if j < Ny+1 && i~=1
            if Phi(j,i) >= 0 && Phi(j+1,i-1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if j < Ny+1 && j~=1 && i~=Nx+1
            if Phi(j,i) >= 0 && Phi(j-1,i+1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if j < Ny+1 && j~=1 && i~=1 && j~=Ny+1 && i~=Nx+1
            if Phi(j,i) >= 0 && Phi(j+1,i-1) < 0 && Phi(j-1,i+1) < 0
                Mark(j,i) = 0.5;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
        if j == Ny+1 && i~=Nx+1
            if Phi(j,i) >= 0 && Phi(j-1,i+1) < 0
                Mark(j,i) = 1;
                index1(k+1) = j;
                index2(k+1) = i;
                k = k+1;
            end
        end
    end
end

%%% check to make sure cell boundary is not leaving computational domain
bdyondomain = [Mark(1,:)' ; Mark(:,1) ; Mark(Ny+1,:)' ; Mark(:,Nx+1)];
if max(bdyondomain) > 0
    Vzeta(1,1) = NaN;
    return
end

% calculate velocity
if k > 0
    for m = 1:k
        j = index1(m);
        i = index2(m);
        if Mark(j,i) == 1 && j == 1
            r = - Phi(j,i)/(Phi(j+1,i-1)-Phi(j,i));
            %%% interface very close to index1(m)=1 outer boundary
            Vzeta(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*sqdxdy);
            Vzeta(j+1,i-1) = Vzeta(j,i);
        end
        if Mark(j,i) == 1 && j == Ny+1
            r = Phi(j,i) / (Phi(j,i)-Phi(j-1,i+1));
            %%% interface very close to index1(m)=N+1 outer boundary
            Vzeta(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*sqdxdy);
            Vzeta(j-1,i+1) = Vzeta(j,i);
        end
        if Mark(j,i) == 1 && Phi(j+1,i-1) < 0
            r = Phi(j,i)/(Phi(j,i)-Phi(j+1,i-1));
            if r <= Tol_r %%% interface very close to index1(m)
                Vzeta(j,i) = D/(out-bdy)*(C(j-1,i+1)-bdy)/...
                    ((1+r)*sqdxdy);
                Vzeta(j+1,i-1) = Vzeta(j,i);
            else
                Vzeta(j,i) = D/(out-bdy)*(C(j,i)-bdy)/(r*sqdxdy);
                Vzeta(j+1,i-1) = Vzeta(j,i);
            end
        end
        if Mark(j,i) == 1 && Phi(j-1,i+1) < 0
            r = - Phi(j,i) / (Phi(j-1,i+1)-Phi(j,i));
            if r <= Tol_r  %%% interface very close to index1(m)
                Vzeta(j,i) = D/(out-bdy)*(bdy-C(j+1,i-1))/...
                    ((1+r)*sqdxdy);
                Vzeta(j-1,i+1) = Vzeta(j,i);
            else
                Vzeta(j,i) = D/(out-bdy)*(bdy-C(j,i))/(r*sqdxdy);
                Vzeta(j-1,i+1) = Vzeta(j,i);
            end
        end
        if Mark(j,i) == 0.5
            r1 = Phi(j,i)/(Phi(j,i)-Phi(j+1,i-1));
            if r1 == 0
                vel1 = 0;
            else
                vel1 = D/(out-bdy)*(C(j,i)-bdy)/(r1*sqdxdy);
            end
            r2 = -Phi(j,i)/(Phi(j-1,i+1)-Phi(j,i));
            if r2 == 0
                vel2 = 0;
            else
                vel2 = D/(out-bdy)*(bdy-C(j,i))/(r2*sqdxdy);
            end
            Vzeta(j+1,i-1) = vel1;
            Vzeta(j-1,i+1) = vel2;
            if r1 < r2
                Vzeta(j,i) = vel1;
            else
                Vzeta(j,i) = vel2;
            end
        end
    end
end

%%% gradient in zeta direction
GPhi_zeta = ones(size(Phi));
GPhi_zeta(2:end-1,2:end-1) = (Phi(1:end-2, 3:end) - ...
    Phi(3:end,1:end-2))/(2*sqdxdy);
GPhi_zeta(2:end,1) = (Phi(1:end-1,2) - Phi(2:end,1))/sqdxdy;
GPhi_zeta(1:end-1,end) = (Phi(1:end-1,end)- Phi(2:end,end-1))/sqdxdy;
GPhi_zeta(1,2:end-1) = (Phi(1,2:end-1)-Phi(2,1:end-2))/sqdxdy;
GPhi_zeta(end,2:end-1) = (Phi(end-1,3:end)-Phi(end,2:end-1))/sqdxdy;

GPhi_zeta_end_end_x = interp1(g.x(end-2:end-1),...
    GPhi_zeta(end,end-2:end-1),g.x(end),'linear','extrap');
GPhi_zeta_end_end_y = interp1(g.y(end-2:end-1),...
    GPhi_zeta(end-2:end-1,end),g.y(end),'linear','extrap');
GPhi_zeta(end,end) = (GPhi_zeta_end_end_x+GPhi_zeta_end_end_y)/2;

GPhi_zeta_1_1_x = interp1(g.x(2:3),GPhi_zeta(1,2:3),g.x(1),...
    'linear','extrap');
GPhi_zeta_1_1_y = interp1(g.y(2:3),GPhi_zeta(2:3,1),g.y(1),...
    'linear','extrap');
GPhi_zeta(1,1) = (GPhi_zeta_1_1_x+GPhi_zeta_1_1_y)/2;

%%% advection of velocity in zeta direction
S = sign(Phi.*GPhi_zeta);
dtau = 0.8*min(dx,dy);

U_old = Vzeta;
for i = 1:iter
    Uzetam = zeros(Ny+1,Nx+1);
    Uzetam(1:end-1,2:end) = (U_old(1:end-1,2:end)-U_old(2:end,1:end-1))/dx;
    Uzetam(2:end,1) = Uzetam(1:end-1,2);
    Uzetam(end,1:end-1) = Uzetam(end-1,2:end);
    Uzetam(1,1) = Uzetam(1,2);
    Uzetam(end,end) = Uzetam(end,end-1);

    Uzetap = zeros(Ny+1,Nx+1);
    Uzetap(2:end,1:end-1) = (U_old(1:end-1,2:end)-U_old(2:end,1:end-1))/dx;
    Uzetap(1,2:end) = Uzetap(2,1:end-1);
    Uzetap(1:end-1,end) = Uzetap(2:end,end-1);
    Uzetap(1,1) = Uzetap(2,1);
    Uzetap(end,end) = Uzetap(end-1,end);

    U_new = U_old - dtau*(max(S.*Sigma,0).*Uzetam+min(S.*Sigma,0).*Uzetap);
    U_old = U_new;
end
Vzeta = U_old;

Gs.x = Px;
Gs.y = Py;
Gs.eta = GPhi_eta;
Gs.zeta = GPhi_zeta;
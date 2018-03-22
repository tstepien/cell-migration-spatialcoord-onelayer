function [density,curve,velocity,Phi,plot_times] = onelayer_Fk_kb_varies(param)% [density,curve,velocity,Phi,plot_times] = onelayer_Fk_kb_varies(param)%% This function is the main file that solves the spatial formulation of the% 2-D 1-layer cell migration Stefan problem%           it is assumed that k/b changes linearly over time%% input:%   param = parameters (structure with Fkintcpt,Fkslope,kbintcpt,kbslope,rho0)%        - note that Fk = F/k and kb = k/b due to parameter identifiability%% outputs:%   density    = density%   curve      = boundary location coordinates%   velocity   = average instantaneous normal velocity at the cell layer%                edge%   Phi        = level set%   plot_times = times at which the contours are drawn%% note:%   figureson: figures on? 1=yes, 0=no%   layerequil: layer at equilibrium? 1=yes, 0=no, 0.5=experimentglobal g time Phi_init init_cond reinit figureson layerequil expdens_init;%%%------------------------- initial densites --------------------------%%%param.Fk = param.Fkintcpt;param.kb = param.kbintcpt;if layerequil == 1 %%% inside the colony    init_cond.in = param.rho0*exp(-param.Fk);elseif layerequil == 0    init_cond.in = param.rho0*exp(param.Fk);elseif layerequil == 0.5    init_cond.in = param.rho0*expdens_init;endinit_cond.out = 0; %%% outside the colonyinit_cond.bdy = param.rho0*exp(-param.Fk); %%% on the boundary%%%-------------------------- time parameters --------------------------%%%time.ini = 0;              %%% initial time is 0time.CFL = 0.25;           %%% constant for the CFL condition %0.25time.dt_too_small = 1e-10; %%% minimum time step that can be takentime.simulation_end_early = 0; %%% cell boundary stays within computational                               %%% domain and simulation does not end early                               %%% (set =1 later in code if this changes)%%%------------------------- re-initialization -------------------------%%%reinit.band = 5;reinit.ITERMAX = 10;reinit.TOL = 0.05;%%%---------------------- level sets and density -----------------------%%%Phi0 = Phi_init;C0 = init_cond.bdy + (init_cond.in - init_cond.bdy).*max(sign(Phi0),0) ...     - (init_cond.out - init_cond.bdy).*min(sign(Phi0),0);Phi_old = Phi0;C_old = C0;Phi_new = Phi0;t = time.ini;plot_times = time.ini;%%% plotting and saving contoursif figureson==1    plots_contourdensity(Phi_new,C_old,'first');end%%% for post-processingframecount = 1;curve{1} = contourc(g.x,g.y,Phi_new,[0 0]);density{1} = C0;Phi{1} = Phi0;%%%---------------------------------------------------------------------%%%%%%---------------------------------------------------------------------%%%%%%---------------------------- WHILE LOOP -----------------------------%%%tic;while t < time.end    param.Fk = param.Fkintcpt + t*param.Fkslope;    init_cond.bdy = param.rho0*exp(-param.Fk); %%% on the boundary        param.kb = param.kbintcpt + t*param.kbslope;%%%--------------------- build diffusion matrices ----------------------%%%    [lapl.Lxx,lapl.Lyy] = laplacian_discretize(param);    %     fprintf('t = %g\n',t);    %%%--------------------- 1. calculate the velocity ---------------------%%%    [Vx,Vy,Veta,Vzeta,Gs] = cartesian_velocity(param,Phi_old,C_old);        if max(max(Vx))==0 || max(max(Vy))==0 || max(max(Veta))==0 ...            || max(max(Vzeta))==0        time.simulation_end_early = 1;        disp('cell boundary outside of computational domain')        return    end        if t==0        [vnormal,arclengths] = velocityarclength(Phi_new,curve{1},Vx,Vy);        %%% estimate velocity along entire line segment; segments have        %%% different lengths (longer it is, the more it will contribute to        %%% the velocity) (discretizing integral)        velocity(1) = sum((vnormal(1:end-1) + vnormal(2:end))./2 ...                                            .*arclengths)./sum(arclengths);    end%%%--------------- 1.2 calculate the time step according ---------------%%%%%%---------------------- to stability conditions ----------------------%%%    maxVel = max(abs(Vx(:)))/g.dx + max(abs(Vy(:)))/g.dy ...                + max(abs(Veta(:)))/sqrt(g.dx^2 + g.dy^2) ...                + max(abs(Vzeta(:)))/sqrt(g.dx^2+g.dy^2);    dt_CFL = time.CFL/max(maxVel);               if dt_CFL < time.dt_too_small        disp('Time step too small!')        dt_CFL = time.dt_too_small;    end    dt = .5*dt_CFL;        if t+dt > framecount*time.exp_step        dt = framecount*time.exp_step-t;        t = framecount*time.exp_step; %%% avoids round-off error    else        t = t + dt;    end%%%---------------------- 2. update the level set ----------------------%%%    Phi_new = levelset_update(Phi_old,dt,Vx,Vy,Veta,Vzeta,Gs);    %%%------------------ 2.1 reinitialize the level set -------------------%%%    Phi_new = levelset_reinitialize(Phi_new,0.2*g.dx,3);%%%------------------ 3. solve the diffusion equation ------------------%%%    C_new = solve_diff(param,lapl,C_old,Phi_old,Phi_new,dt);%%%------------ 4. prepare variable for the next time step -------------%%%    C_old = C_new;    Phi_old = Phi_new;%%%------- 5. post-processing: graphical output, find interface --------%%%    if  t == framecount*time.exp_step %%% only plots timesteps that                                      %%% align w/ experimental time points    %         fprintf('t = %g\n',t);                framecount = framecount + 1;                %%% plotting and saving contours        curve{framecount} = contourc(g.x,g.y,Phi_new,[0 0]);        if figureson==1            plots_contourdensity(Phi_new,C_new);        end                density{framecount} = C_new;        area(framecount) = polyarea(curve{framecount}(1,:),...                                                   curve{framecount}(2,:));                [vnormal,arclengths] = velocityarclength(Phi_new,...                                                  curve{framecount},Vx,Vy);                velocity(framecount) = sum((vnormal(1:end-1) ...                        + vnormal(2:end))./2.*arclengths)./sum(arclengths);        Phi{framecount} = Phi_old;                plot_times = [plot_times t];    endend% if figureson==1%     plots_edgevelocity(plot_times,velocity)% endtoc;
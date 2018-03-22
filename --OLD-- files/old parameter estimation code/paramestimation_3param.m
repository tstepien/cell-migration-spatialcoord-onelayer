function min_quantity = paramestimation_3param(param)
% min_quantity = paramestimation_3param(param)
%
% parameter estimation file that contains minimization function
%
% input:
%   param = parameters (vector with Fk,kb,rho0) - note that Fk = F/k and
%           kb = k/b due to parameter identifiability
%
% output:
%   min_quantity = the quantity that is to be minimized in the parameter
%                  estimation

global exp_density exp_boundary time;

% give large penalty if any parameters are negative
if param(1)<=0 || param(2)<=0
    min_quantity = 10^20;
    return
end

% give large penalty if the rho0 parameters are too small or too large
if param(3)<800 || param(3)>8000
    min_quantity = 10^20;
    return
end

simparam.Fk = param(1);
simparam.kb = param(2);
simparam.rho0 = param(3);

[density,curve] = onelayer(simparam);

% give large penalty if cell boundary went beyond the computational domain
% (simulation_end_early = 1)
if time.simulation_end_early==1
    min_quantity = 10^20;
    return
end

L = length(exp_density);

diff_density = cell(1,L);
avgnorm_density = zeros(1,L);
diff_dist = cell(1,L);
avgnorm_dist = zeros(1,L);

for i = 1:L
    mask = exp_density{i}>0;
    diff_density{i} = abs(mask.*density{i} - simparam.rho0*exp_density{i});
    avgnorm_density(i) = norm(diff_density{i}(:));

    for j = 1:length(exp_boundary{i})
        CC = length(curve{i});
        if CC>2
            temp_dist = zeros(1,CC-1);
            for k = 1:CC-1
                temp_dist(k) = abs(find_dist(exp_boundary{i}(1,j),...
                    exp_boundary{i}(2,j),curve{i}(1,[k,k+1]),...
                    curve{i}(2,[k,k+1])));
            end
            diff_dist{i}(j) = min(temp_dist);
        else
            diff_dist{i}(j) = min(sqrt((exp_boundary{i}(1,j) ...
                          - curve{i}(1,:)).^2 + (exp_boundary{i}(2,j) ...
                          - curve{i}(2,:)).^2));
        end
    end
    avgnorm_dist(i) = norm(diff_dist{i});        
end

min_quantity = sum(avgnorm_density) + 10^2*sum(avgnorm_dist);


% function my_quantity = myfunnewTS(params)
% global exp_boundary;
% [density,curve] = onelayer(simparam);
% L = size(density,2);
% 
% % consider adding this in?  add points to numerical curve if the
% % experimental curve has more points in it
% %%loop based on perpendicular distance from experimental point to
% %%computation points to create subset of data points that is the same size
% %%vector as the experimental vector (closest)
% % for i = 1:L
% %     if length(exp_boundary{i}) > length(curve{i})
% %         m = length(curve{i});
% %         centroidx = sum(curve{i}(1,:))/length(curve{i}(1,:));
% %         centroidy = sum(curve{i}(2,:))/length(curve{i}(2,:));
% %         while length(exp_boundary{i}) > length(curve{i})
% %             curve{i}(:,m+1) = [centroidx ; centroidy];
% %             m = length(curve{i});
% %         end
% %     end
% % end
% 
% 
% % probably need to do something more intense later?
% % for i = 1:L
% %     for j = 1:length(exp_boundary{i})
% %         if length(curve{i})>2
% %             for k = 1:(length(curve{i})-1)
% %                 index_begin = k;
% %                 index_end = k+1;
% %                 dist{i}(i,j)= abs(find_dist(exp_boundary{i}(1,j),...
% %                                      exp_boundary{i}(2,j),...
% %                                      curve{i}(1,[index_begin,index_end]),...
% %                                      curve{i}(2,[index_begin,index_end])));
% %             end  %result here is: distja{1:time}(1:predicted line segments,1:experimental points)
% %         else
% %             dist{i}(1,j) = sqrt((exp_boundary{i}(j,1)-curve{i}(1,1))^2 ...
% %                          + (exp_boundary{i}(j,2)-curve{i}(2,1))^2);
% %         end
% %     end
% % end
%     
%     norm_val = zeros(h,1);
%     
%     
%     
%     % for k = 1:length(measured_times)
%     %  Loop through all experimental times
%     % for k = 1:length(exp_boundary)
%     for k = 1:h
%         
%         %  Loop through all experimental points being tracked for a given time
%         for j = 1:length(exp_boundary{k})
%             
%             %  Get minimum distance from given experimental point (j) at given
%             %  time (k) from the corresponding computational curve
%             min_dist{k}(j,1) = min(distja{k}(:,j));  %vector of minimum distance 
%                       %in each column, ie. for each experimental point
%             
%         end
%         %  Find average minimum distance from experimental points to
%         %  computational curve at a given time (k)
%         norm_val(k,1) = 1/length(min_dist{k})*sum(min_dist{k}(:,1));
%         
%     end
%     
%     %  Find total "distance" from experimental to computational curves over all
%     %  time (note no averaging over time)
%     
%     my_quantity = sum(norm_val);
%     
%     % my_quantity = my_quantity+1000*abs(length(exp_boundary)-length(curve));
%     % %%takes into account missing timesteps
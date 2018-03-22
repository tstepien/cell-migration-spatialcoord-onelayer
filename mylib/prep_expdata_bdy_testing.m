function boundaries = prep_expdata_bdy_testing(exp_boundaries,exp_scale)
% boundaries = prep_expdata_bdy(exp_boundaries,exp_scale)
%
% convert the experimental data (boundaries only) from pixels to microns
%
% input:
%   exp_boundaries = file name of experimental boundary data
%   exp_scale      = pixels per micron scale
%
% output:
%   boundaries = experimental boundary coordinates fit to numerical grid

global g;

load(exp_boundaries)

L = size(exp_boundaries,2);

boundaries = cell(1,L);
for i = 1:L
    if isempty(exp_boundaries{i})==0
        [m,n] = size(exp_boundaries{i}); % make sure matrix is vertical
        if m<n
            exp_boundaries{i} = exp_boundaries{i}';
        end
        % 1st column of coord corresponds to x
        % 2nd column of coord corresponds to y
        % scale and translate from pixels to microns
% % %         boundaries{i} = [exp_boundaries{i}(:,1)/exp_scale + g.xmin , ...
% % %             exp_boundaries{i}(:,2)/exp_scale + g.ymin];
        boundaries{i} = exp_boundaries{i};
    end
end
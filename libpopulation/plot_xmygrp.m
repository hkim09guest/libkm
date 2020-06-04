function hP = plot_xmygrp(x, y, grp, varargin)
% plot population response to diferent stimuli
% plot_xmygrp(x,y,grp, sline)
% plot'm' means that y is a matrix
% x: (1 * n) preference of neurons
% y: (m trials * n) responses
% grp: (m trials * 1) stimulus parameters

sline = [];
show_individual = 1;
show_average = 1;
grp_name = {};

process_varargin(varargin);

if ~is_arg('grp')
    grp = ones(size(y,1),1);
end

assert(size(x,2)==size(y,2), 'size(x,2): %d should be same as size(y,2): %d', size(x,2), size(y,2));
assert(size(y,1)==size(grp,1), 'size(y,1): %d should be same as size(grp,1): %d', size(y,1), size(grp,1));

if ~is_arg('sline'), sline = '-'; end;

uG = unique(grp);
if isempty(grp_name)
    grp_name = arrayfun(@(x) sprintf('%.2f',x), uG,'uniformoutput',false);
end

assert(numel(uG) == numel(grp_name), '# of groups should match with # of group names');
cmap = get_cmap(numel(uG));
cla; hold on;
hInd = []; hAvg = [];
for iG=1:length(uG)
    if show_individual
        hInd = plot(x, y(grp==uG(iG),:)', sline , 'color', brighter(cmap(iG,:),2) );
        if ~isempty(hInd), hInd = hInd(1); end;
    end
    if show_average
        hAvg = draw_errorbar(x, nanmean( y(grp==uG(iG),:) ), nansem( y(grp==uG(iG),:)), ...
            cmap(iG,:), 'patch', gca ) ;
        if ~isempty(hAvg), hInd = hAvg(1); end;
    end
    tmp = [hInd hAvg];
    hP(iG,:) = tmp;
end
hold off;

legend(hP(:,1), grp_name);
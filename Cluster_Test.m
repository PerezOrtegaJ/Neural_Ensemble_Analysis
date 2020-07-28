function [recommended,indices] = Cluster_Test(treeOrData,similarity,metric,clusteringMethod,groups,fig)
% Clustering indexes
% Get indexes for evaluating clustering from hierarchical cluster tree
%
%       [recommended,indices] = Cluster_Test(treeOrData,similarity,metric,clusteringMethod,groups,fig)
%
%       default: metric = 'contrast'; clusteringMethod = 'hierarchical';
%                groups = 2:30; fig = []
%
% Inputs:
%      treeOrData = hierarchical cluster tree, or data for k-means
%      similarity = matrix PxP (P=#peaks) for metrics Dunn &
%                    Contrast; Xpeaks, peaks vectors as matrix PxC for metrics
%                    Connectivity & Davies
%                    (P = #peaks; C=#cells)
%      metric = index to compute ('dunn','connectivity','davies','contrast')
%      clusteringMethod,groups
%      numFig = number of the figure to plot
%
% Outputs:
% indices = clustering indices of 'metric' from 2 to 10 groups
% recommended = recommended number of clusters
%
% ..:: by Jesús E. Pérez-Ortega ::.. Jun-2012
% modified March-2018
% modified Apr 2020

switch(nargin)
    case 2
        metric = 'contrast';
        clusteringMethod = 'hierarchical';
        groups = 2:30;
        fig = [];
    
    case 3
        clusteringMethod = 'hierarchical';
        groups = 2:30;
        fig = [];
    case 4 
        groups = 2:30;
        fig = [];
    case 5 
        fig = [];
end

dist = 1-similarity;
j = 1;
for i = groups
    switch(clusteringMethod)
        case 'hierarchical'
            T = cluster(treeOrData,'maxclust',i);
        case 'kmeans'
            T = kmeans(treeOrData,i);
    end
    g = max(T);
    
    switch(metric)
        case 'dunn'
            indices(j) = DunnIdx_JP(g,dist,T);
        case 'connectivity'
            indices(j) = CCidx2_JP(g,similarity,T);
        case 'davies'
            indices(j) = DaviesIdx_JP(g,similarity,T);
        case 'contrast'
            indices(j) = ContrastIdx_JP(g,similarity,T);
    end
    j = j+1;
end

% Old way
% [gIdx,g]=max(indices);
% maximum = groups(g);

% New way
[~,id] = find(diff(indices)>0,1,'first');
if isempty(id) || id==length(groups)-1
    % The indices are decreasing, so select the first
    recommended = groups(1);
    id = 1;
else
    % Find the first peak of the indices
    indicesCopy = indices;
    indicesCopy(1:id) = 0;
    [~,id] = find(diff(indicesCopy)<0,1,'first');
    if isempty(id)
        % If there is no peak find the first sudden increase
        [~,id] = find(diff(diff(indicesCopy))<0,1,'first');
        id = id+1;
    end
    recommended = groups(id);
end

% Plot 
if ~isempty(fig)
    plot(groups,indices)
    hold on
    plot(recommended,indices(id),'*r')
    hold off
    title([metric '''s index (' num2str(recommended) ' groups recommended)'])
    xlabel('number of groups')
    ylabel('index value')
end
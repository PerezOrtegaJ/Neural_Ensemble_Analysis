% Clustering indexes
% Get indexes for evaluating clustering from hierarchical cluster tree
%
% [ClustIdx g] = ClustIdx_JP(Tree, SimOrXpeaks, Metric, numFig)
%
% Inputs
% Tree = hierarchical cluster tree
% SimOrXpeaks = Sim, similarity as matrix PxP (P=#peaks) for metrics Dunn &
%               Contrast; Xpeaks, peaks vectors as matrix PxC for metrics
%               Connectivity & Davies
%               (P = #peaks; C=#cells)
% Metric = index to compute ('Dunn','Connectivity','Davies','Contrast')
% numFig = number of the figure to plot
%
% Output
% ClustIdx = clustering indexes of 'Metric' from 2 to 10 groups
% g = best number of groups according to the index selected
%
% ..:: by Jesús E. Pérez-Ortega ::.. Jun-2012
% modified March-2018

function [ClustIdx g] = ClustIdx_JP(tree_or_data,similitud,method,num_fig, clust_method,groups)

if(nargin==5)
    groups=2:30;
end

dist=1-similitud;
j=1;
for i=groups
    switch(clust_method)
        case 'hierarchical'
            T = cluster(tree_or_data,'maxclust',i);
        case 'kmeans'
            T = kmeans(tree_or_data,i);
    end
    g=max(T);
    
    switch(method)
        case 'Dunn'
            ClustIdx(j)=DunnIdx_JP(g,dist,T);
        case 'Connectivity'
            ClustIdx(j)=CCidx2_JP(g,similitud,T);
        case 'Davies'
            ClustIdx(j)=DaviesIdx_JP(g,similitud,T);
        case 'Contrast'
            ClustIdx(j)=ContrastIdx_JP(g,similitud,T);
        otherwise
            method='Dunn';
            ClustIdx(j)=DunnIdx_JP(g,dist,T);
    end
    j=j+1;
end
figure(num_fig)
plot(groups,ClustIdx)
hold on

[gIdx,g]=max(ClustIdx);

plot(groups(g),gIdx,'*r')
hold off
title([method '''s index (' num2str(groups(g)) ' groups recommended)'])

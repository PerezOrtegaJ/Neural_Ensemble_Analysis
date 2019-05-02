% Dunn's Index
% Get the Dunn's index for g groups given a distance matrix.
%
% [DI] = DunnIdx(g,dist,idx)
%
% Inputs
% g = number of groups
% dist = square distance matrix
% idx = indexes of group to which each data point belongs
% 
% Outputs
% DI = Dunn's index
%
% ..:: by Jesús E. Pérez-Ortega ::.. Mar-2012

function [DI] = DunnIdx_JP(g,dist,idx)

min_inter=[];   % minimal distance inter-group
max_intra=[];   % maximal distance intra-group
for i=1:g
    g_i=find(idx==i);
    g_other=find(idx~=i);
    min_inter(i)=min(min(dist(g_i,g_other)));
    max_intra(i)=max(max(dist(g_i,g_i)));
end
min_inter=min(min_inter);
max_intra=max(max_intra);

DI=min_inter/max_intra;




function [raster_sorted,indices,distance_sorted,distance] = Sort_Raster_By_Distance(raster,signal,method)
% Get indices of neurons sorted by distance from a given signal
%
%       [raster_sorted,indices,distance] = Sort_Raster_By_Distance(raster,signal,method)
%
%       default: method = 'correlation'
%
% Perez-Ortega Jesus - June 2019

if nargin==2
    method = 'correlation';
end

neurons = size(raster,1);
distance = zeros(neurons,1);

% Compute linear correlation
for i = 1:neurons
    distance(i) = pdist([signal';raster(i,:)],method);
end

% Get indices sorted
[~, indices] = sort(distance);

% Return raster sorted
raster_sorted = raster(indices,:);
distance_sorted = distance(indices);
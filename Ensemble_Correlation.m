function [correlation,cell_indices] = Ensemble_Correlation(raster,indices,sequence,group)
% Compute correlation between neurons and single ensemble
%
%       [correlation,cell_indices] = Ensemble_Correlation(raster,indices,sequence,group)
%
% By Jesus Perez-Ortega, Apr 2020

neurons = size(raster,1);

% find indices of group peaks
idGroup = find(sequence==group)';
idIndices = zeros(size(indices));
for i = idGroup
    idIndices(indices==i) = 1;
end
%signal = signal.*idIndices;  % old
signal = idIndices;           % correlation with binary

% compute correlation
for i=1:neurons
    D(i) = pdist([signal';raster(i,:)],'correlation');
end
correlation = 1-D;
correlation(isnan(correlation)) = 0;
correlation(correlation<0) = 0;
% sort
[~, cell_indices] = sort(correlation,'descend');
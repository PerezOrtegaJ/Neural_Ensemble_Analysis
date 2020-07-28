function [within,count] = Similarity_Within_Rasters(rastersEnsemble)
% Get similarity within raster ensembles
%
%       [within,count] = Similarity_Within_Rasters(rastersEnsemble)
%
% By Jesus Perez-Ortega, Apr 2020

nEnsembles = length(rastersEnsemble);

% Similarity between A and B
for i = 1:nEnsembles
    % Get raster from A
	rA = rastersEnsemble{i};
    
    % Get number of peaks
    count(i) = size(rA,2);
    
    % Get similarity
    within(i) = mean(1-pdist(double(rA'),'jaccard'));
end

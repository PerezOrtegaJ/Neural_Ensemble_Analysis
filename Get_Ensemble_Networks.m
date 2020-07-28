function [networks,rasters,raws] = Get_Ensemble_Networks(raster,vectorID,sequence)
% Get a network from each ensemble
%
%       [networks,rasters,raws] = Get_Ensemble_Networks(raster,vectorID,sequence)
%
% By Jesus Perez-Ortega, Apr 2020
% Modified May 2020

% Get number of ensembles
ensembles = length(unique(sequence));

% Get ensemble network
for i = 1:ensembles
    
    % Get raster ensemble
    peaks = find(sequence==i);
    indicesPeak = [];
    for j = 1:length(peaks)
        indicesPeak(j) = find(vectorID==peaks(j));
    end
    rasters{i} = raster(:,indicesPeak);
    
    % Get networks and neuronal structure
    correlation = Ensemble_Correlation(raster,vectorID,sequence,i);
    [networks{i},raws{i}] = Get_Significant_Network_From_Raster_And_Correlation(...
        rasters{i},correlation);
end
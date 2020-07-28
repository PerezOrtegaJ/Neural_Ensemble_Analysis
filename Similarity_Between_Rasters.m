function betweenAB = Similarity_Between_Rasters(rastersEnsembleA,rastersEnsembleB)
% Get similarity between ensembles from different days or conditions
%
%       betweenAB = Similarity_Between_Rasters(rastersEnsembleA,rastersEnsembleB)
%
% By Jesus Perez-Ortega, May 2020

nEnsemblesA = length(rastersEnsembleA);
nEnsemblesB = length(rastersEnsembleB);

% Similarity between A and B
for i = 1:nEnsemblesA
    % Get raster from A
	rA = rastersEnsembleA{i};
    
    for j = 1:nEnsemblesB    
        % Get raster from B
        rB = rastersEnsembleB{j};
        
        % Get number of peaks
        nA = size(rA,2);
        nB = size(rB,2);

        % Get similarity
        betweenAB(j,i) = mean(1-pdist2(double(rA'),double(rB'),'jaccard'),'all');
    end
end

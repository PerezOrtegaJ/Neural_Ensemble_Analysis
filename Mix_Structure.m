function [structureMixed,id] = Mix_Structure(analysis,similar)
% Mix the structure between different days
%
%       [structureMixed,id] = Mix_Structure(analysis,similar)
%
% By Jesus Perez-Ortega, May 2020

% Get number of days
n = length(analysis);

% Get number of neurons
nNeurons = length(analysis(1).Network);

% Get number of ensembles
nEnsembles = size(similar,1);

% Mix structure
structureMixed = zeros(nEnsembles,nNeurons);
for i = 1:nEnsembles
    for j = 1:n
        if similar(i,j)
            structureMixed(i,:) = structureMixed(i,:)|...
                analysis(j).Ensembles.Structure(similar(i,j),:);
        end
    end
end

% Sort cells given the mixed structure
[~,id] = Sort_Raster(structureMixed','descend');
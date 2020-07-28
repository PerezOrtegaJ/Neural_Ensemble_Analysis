function [structure,networkMixed] = Get_Ensemble_Identity(networks)
% Identify which ensembles the neurons belong to, and get the mixed network.
%
%       [structure,networkMix] = Get_Ensemble_Ientity(networks)
%
% By Jesus Perez-Ortega, May 2020

% Get the number of ensembles and neurons
nNetworks = length(networks);
nNeurons = length(networks{1});

% Get identity of neurons
structure = zeros(nNetworks,nNeurons);
networkMixed = zeros(nNeurons);
for i = 1:nNetworks
    if ~isempty(networks{i})
        id = sum(networks{i})>0;
        if ~isempty(id)
            structure(i,id) = i;
            if isempty(networkMixed)
                networkMixed = zeros(length(networks{i}));
            end
            networkMixed = networkMixed + networks{i};
        end
    end
end
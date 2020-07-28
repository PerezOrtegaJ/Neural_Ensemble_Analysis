function [l,e,c,comps,indices] = Network_Resilience(adjacency,method,user_indices)
% Resilience of a binary undirected network
%
%       [l,e,c,comps,indices] = Network_Resilience(adjacency,method,user_indices)
%
%       default: method = 'error'
%
% output:
%	l      characteristic path length 
%	e      eficiency
%	c      clustering coeficient
%	comps  components
%
% by Jesus Perez-Ortega, Nov-2017
% modified June 2019

% Get the number of nodes
n = length(adjacency);

if nargin==1
    method = 'error';
end

% Assign indices
switch method
    case 'error'
        indices = randperm(n);
    case 'attack'
        [~,indices] = sort(sum(adjacency),'descend');
    case 'custom'
        indices = user_indices;
end

% Remove neurons
all_nodes = 1:n;
for i=1:n-1
    % Delete elements from matrix
    id = setdiff(all_nodes,indices(1:i));
    trimmed = adjacency(id,id);

    % Characteristic path length and efficiency
    D = distance_bin(trimmed);
    [l(i), e(i)] = charpath(D);

    % Clustering coefficient
    clocal = clustering_coef_bu(trimmed);
    c(i) = mean(clocal);

    % Components
    %comps(i) = max(get_components(trimmed))/(n-i);
    comps(i) = max(get_components(trimmed));
end

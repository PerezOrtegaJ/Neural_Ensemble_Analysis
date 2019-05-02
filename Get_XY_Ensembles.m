function [xy, xy_colors, id, structure] = Get_XY_Ensembles(networks)
% Get coordinate of ensembles
%
%       [xy, xy_colors, id, structure] = Get_XY_Ensembles(networks)
%
% Jesus Perez-Ortega April-19

% Get number of networks
n_networks = length(networks);
n_neurons = length(networks{1});
colors = Read_Colors(n_networks);

% Get identity of neurons
structure = zeros(n_networks,n_neurons);
network = zeros(n_neurons);
for i = 1:n_networks
    id_i = sum(networks{i})>0;
    if ~isempty(id_i)
        structure(i,id_i) = i;
        network = network | networks{i};
    end
end

% Set XY for neurons without connections
id_inactive = find(sum(structure>0)==0);
xy_inactive = Get_Circular_XY(length(id_inactive),3);

% Set XY for neurons of specificity
alone = sum(structure>0)==1;
xy_base = Get_Circular_XY(n_networks,2);
xy_specific = [];
id_specific = [];
for i = 1:n_networks
    % get neurons id
    id_i = find(alone & structure(i,:));
    
    
    if length(id_i)==1
         % Add to the existing
        xy_specific = [xy_specific; [0 0]];
        id_specific = [id_specific id_i];
    elseif length(id_i)>1
        % Get network specific-state neurons
        net = networks{i}(id_i,id_i);
        
        % Get coordinates
        xy_i = Scale(Get_Force_XY(net),-1,1) + xy_base(i,:);

        % Add to the existing
        xy_specific = [xy_specific; xy_i];
        id_specific = [id_specific id_i];
    end
end
% Set XY for hub neurons
id_hubs = find(sum(structure>0)>1);
[~,id_new] = Sort_Raster(flipud(structure(:,id_hubs))','ascend');
id_hubs = id_hubs(id_new);
xy_hubs = Scale(Get_Force_XY(network(id_hubs,id_hubs)),-1,1);

% Join
id = [id_specific id_hubs id_inactive];
xy = [xy_specific; xy_hubs; xy_inactive];
structure = structure(:,id);

% Colors
xy_colors = zeros(n_neurons,3);
for i = 1:n_neurons
    id_color = find(structure(:,i));
    if isempty(id_color)
        xy_colors(i,:) = [0 0 0];
    elseif length(id_color)==1
        xy_colors(i,:) = colors(id_color,:);
    else
        xy_colors(i,:) = [0.5 0.5 0.5];
        %xy_colors(i,:) = mean(colors(id_color,:));
    end
end
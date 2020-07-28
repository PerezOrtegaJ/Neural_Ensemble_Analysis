function [xy,xyColors,xySpecial,id,structure] = Get_XY_Ensembles(networks)
% Get coordinate of ensembles
%
%       [xy,xyColors,xySpecial,id,structure] = Get_XY_Ensembles(networks)
%
% Jesus Perez-Ortega April-19
% Modified Dec 2019
% Modified Apr 2020

% Get number of networks
n_networks = length(networks);
n_neurons = length(networks{1});
colors = Read_Colors(n_networks);

% Get identity of neurons
[structure,networkMixed] = Get_Ensemble_Identity(networks);

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
        xy_i = rescale(Get_Force_XY(net),-1,1) + xy_base(i,:);

        % Add to the existing
        xy_specific = [xy_specific; xy_i];
        id_specific = [id_specific id_i];
    end
end
% Set XY for hub neurons
id_hubs = find(sum(structure>0)>1);
[~,id_new] = Sort_Raster(flipud(structure(:,id_hubs))','ascend');
id_hubs = id_hubs(id_new);
xy_hubs = rescale(Get_Force_XY(networkMixed(id_hubs,id_hubs)),-1,1);

% Join
id = [id_specific id_hubs id_inactive];
xy = [xy_specific; xy_hubs; xy_inactive];

% Colors
[xyColors,xySpecial] = Get_Colors_From_Structure(structure);
function xy = Plot_Ensembles(network,xy,xyColors,xySpecial,structure,name,save)
% Plot ensembles
%
%       xy = Plot_Ensembles(network,xy,xyColors,xySpecial,structure,name,save)
%
% Jesus Perez-Ortega April-19
% Modified Dec 2019

switch(nargin)
    case 4
        name = '';
        save = false;
    case 5
        save = false;
end

% Get data
[n_networks,n_neurons] = size(structure);

if isempty(xy)
    % Identify inactive
    n_inactive = length(find(sum(network)==0));
    
    % Generate internal circular XY for active
    xy_1 = Get_Circular_XY(n_neurons-n_inactive);
    
    % Generate external circular XY for inactive
    xy_2 = Get_Circular_XY(n_inactive,1.1);
    xy = [xy_1;xy_2];
end

% Plot ensembles
Set_Figure(['Network - ' name],[0 0 600 600]);
Plot_Network(network,'undirected',xy,xyColors,xySpecial);
if save
    Save_Figure(['Network - ' name])
end

Set_Figure(['Single networks ' name],[0 0 900 900]);
rows = ceil(n_networks/2);
xyColors = Read_Colors(n_networks);
for i = 1:n_networks
    id = find(structure(i,:));
    subplot(rows,2,i)
    Plot_Network(network(id,id),'undirected',xy(id,:),xyColors(i,:),xySpecial(id));
    title(['# ' num2str(i)])
    xlim([-1 1])
    ylim([-1 1])
end
if save
    Save_Figure(['Single networks - ' name])
end

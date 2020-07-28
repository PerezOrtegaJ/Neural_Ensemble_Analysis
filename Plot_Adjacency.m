function Plot_Adjacency(adjacency)
% Plot binary adjacency matrix
%
%       Plot_Adjacency(adjacency)
%
% By Jesus Perez-Ortega, Nov 2019

% Plot adjacency matrix
ax = gca;
imagesc(adjacency);

% Set colormap in black and white
colormap(ax,[1 1 1; 0 0 0]);

% Set square aspect
pbaspect([1 1 1])
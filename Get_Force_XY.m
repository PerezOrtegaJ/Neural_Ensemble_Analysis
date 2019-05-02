function xy = Get_Force_XY(adjacency)
% Get coordinates to plot network in 2D with force layout
%
%       xy = Get_Force_XY(adjacency)
%
% Jesús Pérez-Ortega nov 2018

if isempty(adjacency)
    xy = [];
    return
end

% Get coordinates 
G=graph(adjacency);
figure();
%G_plot=plot(G,'Layout','force','usegravity',true);
%G_plot=plot(G,'Layout','force','weighteffect','direct');
%G_plot=plot(G,'Layout','force','usegravity',true,'iterations',250);
G_plot=plot(G,'Layout','force','iterations',250);
xy = [G_plot.XData' G_plot.YData'];
close;
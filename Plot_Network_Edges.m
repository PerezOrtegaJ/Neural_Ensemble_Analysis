function xy = Plot_Network_Edges(adjacency,type,xy,xyColors)
% Plot weighted and undirected network edegs with loops
%
%       xy = Plot_Network_Edges(adjacency,type,xy,xyColors)
%
%       default: type = 'undirected'; xy = 'circle'; xy_colors = Read_Colors(n);
%
% Pérez-Ortega Jesús - Dec 2019

n = length(adjacency);
switch nargin
    case 3
        xyColors = Read_Colors(n);
    case 2
        xyColors = Read_Colors(n);
        xy = 'circle';
    case 1
        xyColors = Read_Colors(n);
        xy = 'circle';
        type = 'undirected';
end

% If user only enter one color
if size(xyColors,1)==1
    xyColors = repmat(xyColors,n,1);
end

% If enter empty xy
lims = [];
if isempty(xy)
    xy = 'circle';
end

if ischar(xy)
    switch xy
        case 'circle'
            nodes = length(adjacency);
            xy = Get_Circular_XY(nodes);
            lims = [-1.5 1.5];
        case 'force'
            xy = Get_Force_XY(adjacency>0);
    end
end

C = length(adjacency);

% Plot edges
curved = 0;
if(sum(adjacency(:)))
    line_widths = zeros(C);
    line_widths(adjacency>0) = rescale(adjacency(adjacency>0),0.5,5);
    hold on
    for a = 1:C
        for b = a:C
            if adjacency(a,b)
                if strcmp(type,'directed')
                    length_arrow = 3+0.5*line_widths(a,b);
                elseif strcmp(type,'undirected')
                    length_arrow = 0;
                else
                    error('type should be: ''undirected'' or ''directed''')
                end
                edgeColor = mean([xyColors(a,:);xyColors(b,:)]);
                Plot_Edge(xy(a,:),xy(b,:),curved,length_arrow,line_widths(a,b),...
                    edgeColor);
            end
        end
    end
end

axis off
%set(gca,'xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1 1])
if lims
    xlim(lims)
    ylim(lims)
% else
%     xlim([min(xy(:,1)) max(xy(:,1))])
%     ylim([min(xy(:,2)) max(xy(:,2))])
end

pbaspect([1 1 1])

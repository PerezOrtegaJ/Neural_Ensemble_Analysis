function xy = Plot_Network(adjacency,type,xy,xyColors,xySpecial,nodeSize,nodeNumber)
% Plot weighted and undirected network with loops
%
%       xy = Plot_Network(adjacency,type,xy,xyColors,xySpecial,nodeSize,nodeNumber)
%
%       default: type = 'undirected'; xy = 'circle'; xyColors = Read_Colors(n);
%                xySpecial = ones(n,1); node_number = false; node_size=10;
%
% Pérez-Ortega Jesús - April 2018 
% Modified April 2019
% Modified Dec 2019

n = length(adjacency);
switch nargin
    case 6
        nodeNumber = false;
    case 5
        nodeNumber = false;
        nodeSize = 10;
    case 4 
        nodeNumber = false;
        nodeSize = 10;
        xySpecial = [];
    case 3
        nodeNumber = false;
        nodeSize = 10;
        xySpecial = [];
        xyColors = Read_Colors(n);
    case 2
        nodeNumber = false;
        nodeSize = 10;
        xySpecial = [];
        xyColors = Read_Colors(n);
        xy = 'circle';
    case 1
        nodeNumber = false;
        nodeSize = 10;
        xySpecial = [];
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

if isempty(xySpecial)
    xySpecial = ones(n,1);
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

links = sum(adjacency);
if length(nodeSize)==1
    sizes_in = ones(1,C)*nodeSize;
%     if sum(links) && nodeSize
%         sizes_in = rescale(sum(adjacency),nodeSize,nodeSize*2);
%     else
%         sizes_in = ones(1,C)*30;
%     end
else
    sizes_in = rescale(nodeSize,10,50);
end

% Plot nodes
for i = 1:C
    if links(i)
        if xySpecial(i)
            plot(xy(i,1),xy(i,2),'.k','MarkerSize',sizes_in(i)+10)
            plot(xy(i,1),xy(i,2),'.','color',xyColors(i,:),'MarkerSize',sizes_in(i))
        else
            plot(xy(i,1),xy(i,2),'.k','MarkerSize',sizes_in(i)+10)
            plot(xy(i,1),xy(i,2),'.','color',mean([xyColors(i,:); 0 0 0]),'MarkerSize',sizes_in(i))
        end
        
        if nodeNumber
            %text(xy(i,1)*1.1,xy(i,2)*1.1,num2str(i),'HorizontalAlignment','Center')
            text(xy(i,1),xy(i,2),num2str(i),'HorizontalAlignment','center')
        end
    else
        plot(xy(i,1),xy(i,2),'.','color',mean([0.5 0.5 0.5; xyColors(i,:)]),...
            'MarkerSize',sizes_in(i)*.2)
    end
end
axis off
%set(gca,'xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1 1])
if lims
    xlim(lims)
    ylim(lims)
else
    xlim([min(xy(:,1)) max(xy(:,1))])
    ylim([min(xy(:,2)) max(xy(:,2))])
end

pbaspect([1 1 1])

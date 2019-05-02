function Plot_Network(adjacency,type,xy,xy_colors,link_color,node_size,node_number)
% Plot weighted and undirected network with loops
%
%       Plot_Network(adjacency,xy,xy_colors,link_color,node_size,node_number)
%
% Pérez-Ortega Jesús - april 2018 
% Modified Jan 2019
% Modified April 2019

n=length(adjacency);
switch (nargin)
    case 6
        node_number=false;
    case 5
        node_number=false;
        node_size=10;
    case 4
        node_number=false;
        node_size=10;
        link_color=[0.5 0.5 0.5];
    case 3
        node_number=false;
        node_size=10;
        link_color=[0.5 0.5 0.5];
        xy_colors = Read_Colors(n);
    case 2
        node_number=false;
        node_size=10;
        link_color=[0.5 0.5 0.5];
        xy_colors = Read_Colors(n);
        xy = [];
    case 1
        node_number=false;
        node_size=10;
        link_color=[0.5 0.5 0.5];
        xy_colors = Read_Colors(n);
        xy = [];
        type = 'undirected';
end

if(size(xy_colors,1)==1)
    xy_colors=repmat(xy_colors,n,1);
end

lims = [];
if(nargin==1||isempty(xy))
    nodes=length(adjacency);
    xy=Get_Circular_XY(nodes);
    lims = [-1.5 1.5];
%        xy = Get_Force_XY(adjacency);
end

C=length(adjacency);

% Plot edges
curved = 0;
if(sum(adjacency(:)))
    line_widths = zeros(C);
    line_widths(adjacency>0) = Scale(adjacency(adjacency>0),0.5,5);
    hold on
    for a=1:C
        for b=a:C
            if (adjacency(a,b))
                if strcmp(type,'directed')
                    length_arrow=3+0.5*line_widths(a,b);
                else
                    length_arrow = 0;
                end
                link_color = mean([xy_colors(a,:);xy_colors(b,:)]);
                Plot_Edge(xy(a,:),xy(b,:),curved,length_arrow,line_widths(a,b),...
                    link_color);
            end
        end
    end
end

links=sum(adjacency);
if(length(node_size)==1)
    if(sum(links) && node_size)
        sizes_in=Scale(sum(adjacency),node_size,node_size+40);
    else
        sizes_in=ones(1,C)*30;
    end
else
    sizes_in=Scale(node_size,10,50);
end

% Plot nodes
for i=1:C
    if(links(i))
        plot(xy(i,1),xy(i,2),'.k','MarkerSize',sizes_in(i)+5)
        plot(xy(i,1),xy(i,2),'.','color',xy_colors(i,:),'MarkerSize',sizes_in(i))
        if(node_number)
            %text(xy(i,1)*1.1,xy(i,2)*1.1,num2str(i),'HorizontalAlignment','Center')
            text(xy(i,1),xy(i,2),num2str(i),'HorizontalAlignment','left')
        end
    else
        plot(xy(i,1),xy(i,2),'.','color',mean([0.5 0.5 0.5; xy_colors(i,:)]),...
            'MarkerSize',sizes_in(i)*.2)
    end
end
set(gca,'xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1 1])
if(lims)
    xlim(lims)
    ylim(lims)
else
    xlim([min(xy(:,1)) max(xy(:,1))])
    ylim([min(xy(:,2)) max(xy(:,2))])
end

pbaspect([1 1 1])

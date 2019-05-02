% Plot weighted and directed network with loops
%
% Pérez-Ortega Jesús - april 2018 
% modified june 2018

function Plot_WD_Network(adjacency,xy,xy_colors,node_size,node_number)
    n=length(adjacency);
    if (nargin==4)
        node_number=false;
    elseif (nargin==3)
        node_number=false;
        node_size=35;
    elseif (nargin==2)
        node_number=false;
        node_size=35;
        xy_colors = Read_Colors(n);
    elseif (nargin==1)
        node_number=false;
        node_size=35;
        xy_colors = Read_Colors(n);
    end
    
    if(nargin==1||isempty(xy))
        nodes=length(adjacency);
        xy=Get_Circular_XY(nodes);
    end

    % Plot edges with arrow
    C=length(adjacency);
    size_factor=5/sum(adjacency(:));
    radius=.15; % Arrow property
    hold on
    for a=1:C
        for b=a:C
            if (adjacency(a,b))
                line_width=adjacency(a,b)*size_factor+.5;
                length_arrow=3+0.5*line_width;
                Plot_Edge(xy(a,:),xy(b,:),radius,length_arrow,line_width);
            end
        end
    end
    for a=1:C-1
        for b=a+1:C
            if (adjacency(b,a))
                line_width=adjacency(b,a)*size_factor+.5;
                length_arrow=3+0.5*line_width;
                Plot_Edge(xy(b,:),xy(a,:),radius,length_arrow,line_width);
            end
        end
    end
    if(sum(adjacency(:)))
        sizes_in=sum(adjacency)./sum(adjacency(:)).*35+node_size;
    else
        sizes_in=ones(1,C)*.35+node_size;
    end
    
    % Plot nodes
    for i=1:C
        plot(xy(i,1),xy(i,2),'.k','MarkerSize',sizes_in(i))
        plot(xy(i,1),xy(i,2),'.','color',xy_colors(i,:),'MarkerSize',sizes_in(i)*.7)
        if(node_number)
            text(xy(i,1)*1.1,xy(i,2)*1.1,num2str(i),'HorizontalAlignment','Center')
        end
    end
    set(gca,'xtick',[],'ytick',[])
    xlim([-1.5 1.5])
    ylim([-1.5 1.5])
    box on
    pbaspect([1 1 1])
end
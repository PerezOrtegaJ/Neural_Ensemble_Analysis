% Plot weighted and binary adjacency and its network

function Plot_Adjacencies_And_Network(adjacency,adjacency_threshold,name,xy,node_color,...
    edge_color,save_plot)
    
    if(nargin==1)
        adjacency_threshold = adjacency;
        name = 'network';
        xy = [];
        node_color = [0.2 0.2 0.2];
        edge_color = [0.5 0.5 0.5];
        save_plot = false;
    elseif(nargin==2)
        name = 'network';
        xy = [];
        node_color = [0.2 0.2 0.2];
        edge_color = [0.5 0.5 0.5];
        save_plot = false;
    elseif(nargin==3)
        xy = [];
        node_color = [0.2 0.2 0.2];
        edge_color = [0.5 0.5 0.5];
        save_plot = false;
    elseif(nargin==4)
        node_color = [0.2 0.2 0.2];
        edge_color = [0.5 0.5 0.5];
        save_plot = false;
    elseif(nargin==5)
        edge_color = [0.5 0.5 0.5];
        save_plot = false;
    elseif(nargin==6)
        save_plot = false;
    end

    size_node = 20;
    numbers = true;
    
    Set_Figure(name,[0 0 1000 300]);
    % Plot weighted adjacency matrix
    subplot(1,3,1)
    imagesc(adjacency); pbaspect([1 1 1])
    title(name)
    % Plot significant adjacency matrix
    ax=subplot(1,3,2);
    imagesc(adjacency_threshold>0); colormap(ax,[1 1 1; 0 0 0]);
    pbaspect([1 1 1])
    % Plot weighted network
    subplot(1,3,3)    
    Plot_Network(adjacency_threshold,'undirected',xy,node_color,edge_color,size_node,numbers);
    % Save Plot
    if(save_plot)
        %Save_Figure(name)
        Save_Figure(name,'eps')
    end
end
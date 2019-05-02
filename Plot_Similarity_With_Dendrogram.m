% Plot Similarity
%
% Pérez-Ortega Jesús - Nov 2018
function Plot_Similarity_With_Dendrogram(data,name,sim_method,linkage_method)
    if(nargin==1)
        name='';
        sim_method='euclidean';
        linkage_method='ward';
    end
    
    [similarity, distance]= Get_Peaks_Similarity(data,sim_method);
    if(~isempty(similarity))
        tree=linkage(squareform(distance,'tovector'),linkage_method);
    else
        error('Similarity matrix could not be created.')
    end
    
    Set_Figure(['Clustering (' name ')'],[0 0 900 300]);
    
    % Plot similarity in time function
    Set_Axes(['SimAxes' name],[0 0 0.33 1]);
    imagesc(similarity)
    set(gca,'YDir','normal')
    title([sim_method ' similarity'])
    xlabel('# peak (t)')
    
    % Plot dendrogram
    Set_Axes(['TreeAxes' name],[0.66 0 0.33 1]);
    dendrogram(tree,0,'orientation','rigth','ColorThreshold','default');
    Tid=str2num(get(gca,'YTicklabel'));
    %set(gca,'xtick',[],'ytick',[])
    title([linkage_method ' linkage'])
    
    % Plot similarity sort by dendrogram
    Set_Axes(['SimSortAxes' name],[0.33 0 0.33 1]);
    imagesc(similarity(Tid,Tid))
    set(gca,'YDir','normal','xtick',[],'ytick',[])
    title('Sort by similarity')
end
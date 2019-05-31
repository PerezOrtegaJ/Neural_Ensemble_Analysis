function Plot_Similarity(similarity,name,tree,sim_method,linkage_method,threshold)
% Plot Similarity
%
%       Plot_Similarity(similarity,name,tree,sim_method,linkage_method)
%
% Pérez-Ortega Jesús - March 2018
% modified May 2019

switch nargin
    case 3
        sim_method='';
        linkage_method='';
        threshold = 'default';
    case 4
        linkage_method='';
        threshold = 'default';
    case 5
        threshold = 'default';
end

Set_Figure(['Clustering (' name ')'],[0 0 900 300]);

% Plot similarity in time function
Set_Axes(['SimAxes' name],[0 0 0.33 1]);
imagesc(similarity)
set(gca,'YDir','normal')
title([sim_method ' similarity'])
xlabel('# peak (t)')

% Plot dendrogram
Set_Axes(['TreeAxes' name],[0.33 0 0.33 1]);
dendrogram(tree,0,'orientation','left','ColorThreshold',threshold);
Tid = str2num(get(gca,'YTicklabel'));
set(gca,'xtick',[],'ytick',[])
title([linkage_method ' linkage'])

% Plot similarity sort by dendrogram
Set_Axes(['SimSortAxes' name],[0.66 0 0.33 1]);
imagesc(similarity(Tid,Tid))
set(gca,'YDir','normal','xtick',[],'ytick',[])
title('Sort by similarity')
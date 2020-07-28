function indices = Plot_Similarity(similarity,name,tree,simMethod,linkageMethod,threshold)
% Plot Similarity
%
%       Plot_Similarity(similarity,name,tree,sim_method,linkage_method)
%
% Pérez-Ortega Jesús - March 2018
% modified May 2019
% modified Dec 2019

switch nargin
    case 3
        simMethod='';
        linkageMethod='';
        threshold = 'default';
    case 4
        linkageMethod='';
        threshold = 'default';
    case 5
        threshold = 'default';
end

if strcmp(linkageMethod,'single') && strcmp(simMethod,'jaccard')
    threshold = 0.3;
end

Set_Figure(['Clustering (' name ')'],[0 0 900 300]);

% Plot similarity in time function
Set_Axes(['SimAxes' name],[0 0 0.33 1]);
imagesc(similarity)
set(gca,'YDir','normal')
title([simMethod ' similarity'])
xlabel('# peak (t)')

% Plot dendrogram
Set_Axes(['TreeAxes' name],[0.33 0 0.33 1]);
[~,~,Tid] = dendrogram(tree,0,'orientation','left');%,'ColorThreshold',threshold);
%Tid = str2num(get(gca,'YTicklabel'));
set(gca,'xtick',[],'ytick',[])
title([linkageMethod ' linkage'])

% Plot similarity sort by dendrogram
Set_Axes(['SimSortAxes' name],[0.66 0 0.33 1]);
imagesc(similarity(Tid,Tid))
set(gca,'YDir','normal','xtick',[],'ytick',[])
title('Sort by similarity')

if nargout == 1
    indices = Tid;
end
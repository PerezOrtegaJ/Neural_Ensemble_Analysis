function Plot_Ensemble_Structure(structure,name,save,colors,figure)
% Plot the structure of the ensembles, representing what are the ensembles
% each neurons belongs
%
%       Plot_Ensemble_Structure(structure,name,colors,save,colors,figure)
%
%       default: name = ''; save = false; colors = Read_Colors(nEnsembles)
%
% By Jesus Perez-Ortega, Feb 2020
% Modified May 2020
% Modified Jun 2020

switch nargin
    case 1
        name = '';
        save = false;
        colors = [];
        figure = true;
    case 2
        save = false;
        colors = [];
        figure = true;
    case 3
        colors = [];
        figure = true;
    case 4
        figure = true;
end

[nEnsembles,nNeurons] = size(structure);

structure = double(structure);
for i = 1:nEnsembles
    structure(i,structure(i,:)>0) = i;
end

if isempty(colors)
    colors = Read_Colors(nEnsembles);
end

% Add a row and a column to plot correctly using pcolor
structure = [[structure; zeros(1,nNeurons)]'; zeros(1,nEnsembles+1)];

% Plot structure
if figure
    Set_Figure(['Structure - ' name],[0 0 40*nEnsembles 300]);
end
pcolor(structure)
colormap(gca,[1 1 1;colors])
xticks(1.5:nEnsembles+0.5)
xticklabels(1:nEnsembles)
yticks(1.5:nNeurons+0.5)
yticklabels(1:nNeurons)
ylabel('neuron #')
xlabel('ensemble #')

% Save figure
if save
    Save_Figure(['Structure - ' name],'','','','1')
end

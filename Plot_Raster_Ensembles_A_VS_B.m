function Plot_Raster_Ensembles_A_VS_B(rastersEnsembleA,rastersEnsembleB,sortingID,name,colors)
% Plot raster sorted by ensembles 
%
%       Plot_Raster_Ensembles_A_VS_B(rastersEnsembleA,rastersEnsembleB,name,colors)
%
%       default: sortingID = []; name = ''; colors = Read_Colors(nEnsembles)
%
% Jesus Perez-Ortega, Apr 2020

switch(nargin)
    case 2
        sortingID = [];
        name = '';
        colors = [];
    case 3
        name = '';
        colors = [];
    case 4
        colors = [];
end

nEnsembles = length(rastersEnsembleA);
nEnsemblesB = length(rastersEnsembleB);

if nEnsembles == nEnsemblesB
    rasterColor = [];
    for i = 1:nEnsembles
        limits(i) = size(rastersEnsembleA{i},2)+size(rasterColor,2);
        rasterColor = [rasterColor ~[rastersEnsembleA{i} rastersEnsembleB{i}]*i];
    end
    if ~isempty(sortingID)
        rasterColor = rasterColor(sortingID,:);
    end

    % Generate colors
    if isempty(colors)
        colors = Read_Colors(nEnsembles);
    end
    colorsBG = colors./3+2/3;
    colorsBG = [0 0 0; colorsBG];
    
    % Plot
    [cells,frames] = size(rasterColor);
    Set_Figure(['Peaks on Raster (' name ')'],[0 0 1220 300]);
    axis([0.5 frames 0.5 cells+0.5]); hold on
    imagesc(rasterColor);
    colormap(colorsBG)
    
    % Plot división between A and B
    for i = 1:nEnsembles
        plot([limits(i) limits(i)],[0 cells+0.5],'color',colors(i,:),...
            'LineWidth',3)
    end
    
    ylabel('neurons')
    title(strrep(name,'_','-'))
else
    error('Length between A an B needs to be the same!')
end
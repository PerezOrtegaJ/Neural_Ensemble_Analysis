function Plot_Raster_Esembles_Through_Days(analysis,recurrent,sortingID,name,colors)
% Plot raster joining the same ensembles from different days
%
%       Plot_Raster_Esembles_Through_Days(analysis,recurrent,sortingID,name,colors)
%
% By Jesus Perez-Ortega, May 2020


switch nargin
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

[nEnsembles,nDays] = size(recurrent);

rasterColor = [];
for i = 1:nEnsembles
    for day = 1:nDays
        ensemble = recurrent(i,day);
        if ensemble
            limits(i,day) = analysis(day).Ensembles.VectorCount(ensemble)+size(rasterColor,2);
            rasterColor = [rasterColor ~[analysis(day).Ensembles.Rasters{ensemble}]*i];
        end
    end
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
    for day = 1:nDays-1
        if limits(i,day)
            plot([limits(i,day) limits(i,day)],[0 cells+0.5],'color',colors(i,:),...
                'LineWidth',3)
        end
    end
end

ylabel('neurons')
title(strrep(name,'_','-'))
function rasterColor = Plot_Peaks_On_Raster(raster,peak_indices,sequence,name,colors)
% Plot Peaks on raster
%
%       Plot_Peaks_On_Raster(raster,peak_indices,sequence,colors)
%
% Pérez-Ortega Jesús - Feb 2020

n = max(sequence);
switch (nargin)
    case 3
        name = '';
        colors = Read_Colors(n);
    case 4
        colors = Read_Colors(n);
end

rasterColor = zeros(size(raster));

% Find vectors
id = find(peak_indices>0);
ensembles(1,:) = unique(sequence);
for i = ensembles
    % find vectors of each ensemble
    x = [];
    x(id(sequence==i)) = 1;
    x = logical(x);
    
    % Assign an numeric value to each ensemble
    rasterColor(:,x) = i;
end

% Assign value of -1 to the spikes (or active frames)
rasterColor(logical(raster)) = -1;

[cells,frames] = size(raster);


Set_Figure(['Peaks on Raster (' name ')'],[0 0 1220 300]);
axis([0.5 frames 0.5 cells+0.5]); hold on
imagesc(rasterColor,[-1 length(ensembles)]);
colormap([0 0 0;1 1 1;colors])

ylim([0.5 cells+0.5])
box on
set(gca,'XTicklabel','','XTick',[0 frames])
title(strrep(name,'_','-'))
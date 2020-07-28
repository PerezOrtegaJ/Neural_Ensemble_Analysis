function vectorSeq = Plot_Raster_Ensembles(raster,sequence,name,newFigure,colors)
% Plot raster sorted by ensembles 
%
%       vectorSeq = Plot_Raster_Ensembles(raster,sequence,name,newFigure,colors)
%
%       default: name = ''; newFigure = false; colors = [];
%
% Jesus Perez-Ortega, Dec 2019
% Modified Jan 2020
% Modified Feb 2020
% Modified Mar 2020
% Modified May 2020
% Modified Jun 2020

switch nargin
    case 2
        name = '';
        newFigure = true;
        colors = [];
    case 3
        newFigure = true;
        colors = [];
    case 4
        colors = [];
end

if iscolumn(sequence)
    sequence = sequence';
end

[cells,frames] = size(raster);
ensembles = unique(sequence);

rasterColor = [];
ids = [];
for i = ensembles
    % Get the raster form ensemble i
    id = find(sequence==i);
    rasterSingle = double(raster(:,id));
    rasterSingle(rasterSingle>0) = -1;
    rasterSingle(rasterSingle==0) = i;
    rasterColor = [rasterColor rasterSingle];
    
    ids = [ids id];
end

if isempty(colors)
    colors = Read_Colors(length(ensembles));
    colors = (colors+2*ones(size(colors)))/3;
end

if newFigure
    Set_Figure(['Peaks on Raster (' name ')'],[0 0 1220 300]);
end
axis([0.5 frames 0.5 cells+0.5]); hold on
imagesc(rasterColor,[-1 length(ensembles)]);
colormap(gca,[0 0 0;1 1 1;colors])
ylabel('neurons')
title(strrep(name,'_','-'))

if nargout
    vectorSeq = ids;
end
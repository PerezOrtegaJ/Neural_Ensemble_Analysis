function Plot_Raster_Limit(cells,sequence,peakLimit)
% Plot division line between each ensemble in the raster
%
%       Plot_Raster_Limit(cells,sequence,peakLimit)
%
% Jesus Perez-Ortega, Feb 2019

ensembles = max(sequence);

sizeVectors = 0;
ensembleLimit = zeros(1,ensembles);
for i = 1:ensembles
    % Get the raster form ensemble i
    ensembleID = find(sequence==i);
    
    % Get the size of vectors in the ensemble
    sizeVectors(i) = length(ensembleID);
    
    % Find the limit of ensamble i+
    if ~isempty(peakLimit)
        limit = find(ensembleID>peakLimit,1,'first');
        if ~isempty(limit)
            if i>1
                ensembleLimit(i) = limit+sum(sizeVectors(1:i-1));
            else
                ensembleLimit(i) = limit;
            end
        else
            if i>1
                ensembleLimit(i) = length(ensembleID)-1+sum(sizeVectors(1:i-1));
            else
                ensembleLimit(i) = length(ensembleID)-1;
            end
        end
    end
end

% Plot raster limit
colors = Read_Colors(ensembles);
for i = unique(sequence')
    plot([ensembleLimit(i) ensembleLimit(i)],[0 cells+0.5],'color',colors(i,:),...
        'LineWidth',3)
end
ylim([0.5 cells+0.5])

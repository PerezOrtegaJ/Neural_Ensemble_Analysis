function [colors,singleEnsemble] = Get_Colors_From_Structure(structure)
% Get colors given a matrix representing the structure of the ensembles
%
%       [colors,singleEnsemble] = Get_Colors_From_Structure(structure)
%
% By Jesus Perez-Ortega

% Get the number of neurons
[nEnsembles,nNeurons] = size(structure);

% Generate colors
ensembleColors = Read_Colors(nEnsembles);

% Assign colors
colors = zeros(nNeurons,3);
singleEnsemble = zeros(nNeurons,1);
for i = 1:nNeurons
    colorID = find(structure(:,i));
    if isempty(colorID)
        % no ensamble, white color
        colors(i,:) = [1 1 1];
    elseif length(colorID)==1
        % single ensemble, single color
        colors(i,:) = ensembleColors(colorID,:);
        singleEnsemble(i) = true;
    else
        % more than one ensemble, gray color
        colors(i,:) = [0.5 0.5 0.5];
        
        % more than one ensemble, mix of colors
        % colors(i,:) = mean(ensembleColors(colorID,:));
    end
end
function Plot_Location_Ensembles_A_And_B(neurons,structureA,structureB,name,colors)
% Plot the location of the ensembles between A and B
%
%       Plot_Location_Ensembles_A_And_B(neurons,structureA,structureB,name,colors)
%
%       default: name = ''; colors = Read_Colors(nEnsembles)
%
% By Jesus Perez-Ortega, Apr 2020
% Modified May 2020

switch nargin
    case 3
        name = '';
        colors = [];
    case 4
        colors = [];
end

% Get number of neurons and ensambles
[nEnsembles,nNeurons] = size(structureA);

if isempty(colors)
    colors = Read_Colors(nEnsembles);
end

Set_Figure(['Ensembles location - ' name],[0 0 300*nEnsembles 300])
for i = 1:nEnsembles
    % Get neurons from same ensemble between A and B
    neuronsA = find(structureA(i,:));
    neuronsB = find(structureB(i,:));
    
    % Get same neurons between A and B
    bothAB = intersect(neuronsA,neuronsB);
    
    % Get neurons only in A or only in B
    singleAB = setdiff(union(neuronsA,neuronsB),bothAB);
    
    % Get colors
    colorsEnsemble = ones(nNeurons,3);
    colorsEnsemble(bothAB,:) = repmat(colors(i,:),length(bothAB),1);
    colorsEnsemble(singleAB,:) = repmat(colors(i,:)/2,length(singleAB),1);
    
    % Get image
    im = Get_Neurons_Image(neurons,256,256,colorsEnsemble); 
    subplot(1,nEnsembles,i)
    imshow(im,'InitialMagnification','fit')
end
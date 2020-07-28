function [within,outside,count] = Get_Ensemble_Similarity(similarity,sequence)
% Get similarity within and outside ensembles
%
%       [within,outside,count] = Get_Ensemble_Similarity(similarity,sequence)
%
% By Jesus Perez-Ortega, Apr 2020

% Get number of ensembles
ensembles = length(unique(sequence));

% Get number of elements
n = length(sequence);

% Get fraction of vectors between days
for i = 1:ensembles
    % Find ensemble indices
    idSame = find(sequence==i);
    idDiff = setdiff(1:n,idSame);
    
    % Count ensemble vectors
    count(i) = length(idSame);
    
    % Get similarity average between ensembles
    within(i) = mean(squareform(similarity(idSame,idSame)-eye(count(i)),'tovector'));
    
    % Get similarity average between ensembles
    outside(i) = mean(similarity(idSame,idDiff),'all');
end
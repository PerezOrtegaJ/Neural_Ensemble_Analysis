function [sim,distance] = Get_Peaks_Similarity(vectors,method)
% Similarity Index
%
% Compute similarity between peak vectors 
%
%       [sim,distance] = Get_Peaks_Similarity(vectors,method)
%
% By Jesus Perez-Ortega Jan-2018
% modified Sep-2018
% modified June 2019
% modified May 2020

if size(vectors,1)>1
    % Compute similarity
    distance = squareform(pdist(vectors,method));
    if max(distance(:))==0
        sim = ones(length(distance));
    else
        switch method
            case {'cosine','correlation','spearman','hamming','jaccard'}
                sim = 1-distance;
            otherwise
                sim = 1-distance/max(distance(:)); % Normalization
        end
    end
else
    warning('There are no data to compare!')
    sim=[];
    distance=[];
end
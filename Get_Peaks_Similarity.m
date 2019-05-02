% Similarity Index
%
% Compute similarity between peak vectors 
%
% By Jes?s P?rez-Ortega Jan-2018
% modified Sep-2018

function [Sim,Distance] = Get_Peaks_Similarity(vectors,Sim_method)
    if(size(vectors,1)>1)
        % Compute similarity
        Distance=squareform(pdist(vectors,Sim_method));
        if(max(Distance(:))==0)
            Sim=ones(length(Distance));
        else
            Sim=1-Distance/max(Distance(:)); % Normalization
            %Sim=1./(1+Distance);
        end
    else
        warning('There are no data to compare!')
        Sim=[];
        Distance=[];
    end
end
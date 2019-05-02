% Get efficiency between a group of vectors
%
% Jesus Perez-Ortega - Sep 2018

function [Efficiency,Error] = Get_Efficiency(vectors)
    [n,length_vector]=size(vectors);
    if(n>1)
        % Compute efficiency
        Error=zeros(n);
        for i=1:n-1
            for j=i+1:n
                error_ij=length(find(abs(vectors(i,:)-vectors(j,:))));
                Error(i,j)=error_ij;
                Error(j,i)=error_ij;
            end
        end
        Error=Error./length_vector;
        Efficiency=1-Error;
    else
        warning('There are no data to compare!')
        Efficiency=[];
        Error=[];
    end
end

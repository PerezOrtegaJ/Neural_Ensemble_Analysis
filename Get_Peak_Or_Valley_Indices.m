% Get peak or valley indices 
%
% by Jes�s E. P�rez-Ortega - Feb 2012

function [indices,count] = Get_Peak_Or_Valley_Indices(data,threshold,detect_peaks)
    if(detect_peaks)
        indices = find(data>=threshold);
    else
        % detect valleys
        indices = find(data<threshold);
    end
    count=numel(indices);
end

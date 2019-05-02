% Get the states sequence in order of appearence
%
% By Jesús Pérez-Ortega jan-2018
% modified march 2018
% modified may 2018

function [peaks_sequence_sorted,idx_sort] = Get_Peaks_Sequence_Sorted(peaks_sequence)
    % Get peak sequence
    idx_group=[];
    groups=max(peaks_sequence);
    for i=1:groups
        idx_group=[idx_group find(peaks_sequence==i,1,'first')];
    end
    [~,idx_sort]=sort(idx_group);

    % Get sequence sorted
    peaks_sequence_sorted=peaks_sequence;
    j=1;
    for i=idx_sort
        peaks_sequence_sorted(peaks_sequence==i)=j;
        j=j+1;
    end
end
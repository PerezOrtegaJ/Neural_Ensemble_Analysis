function [indices,count] = Get_Peak_Or_Valley_Indices(data,threshold,detect_peaks)
% Get peak or valley indices 
%
% by Jesus E. Perez-Ortega - Feb 2012
% Modified June 2019

if detect_peaks
    indices = find(data>threshold);
else
    % detect valleys
    indices = find(data<threshold);
end
count = numel(indices);
% Remove smoothed signal from original
%
% Remove the smoothed loess signal from the original
%
% By Jes?s P?rez-Ortega april-2018

function [smoothed,removed]= Remove_Oscillations(coactivity,percentage)
    if(nargin==1)
        %percentage=0.2;
        percentage=0.01; % 15 min at 1 kH --> 9 s 
    end
    
    removed=smooth(coactivity,percentage,'loess'); % quadratic fit
    smoothed=coactivity-removed;
end
function existFigure = Hold_Figure(titleName)
%% Hold on a Figure with an specific name
%
%       existFigure = Hold_Figure(titleName)
%
% Jesus Perez-Ortega March-18
% Modified Sep 2019

h = findobj('name',titleName);
    
if isempty(h)
    existFigure = false;
else
    figure(h);
    existFigure = true;
end

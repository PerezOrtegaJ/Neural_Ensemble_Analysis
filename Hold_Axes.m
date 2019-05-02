function h = Hold_Axes(axes_tag)
%% Set the axes specified by its tag
%
% Jesus Perez-Ortega March-18
h = findobj('Tag',axes_tag);
if(~isempty(h))
    axes(h);
end
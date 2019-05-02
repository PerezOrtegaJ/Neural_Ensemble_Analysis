function fig = Set_Figure(title_name,position)
%% Set Figure
%
% Create a figure with basic properties: title, size and position. If the 
% figure already exist, it is only cleaned.
%
%       fig = Set_Figure(title_name,position) 
%
% position = [x y width height])
%
% Jesus Perez-Ortega modififed April-19

h = findobj('name',title_name);
if isempty(h)
    h = figure('name',title_name,'numbertitle','off','position',position);
else
    figure(h);
end
clf

if nargout
    fig = h;
end

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
% Modified Oct 2019

if isempty(title_name)
    if nargin == 1
        h = figure('name','unnamed','numbertitle','off');
    else
        h = figure('name','unnamed','numbertitle','off','position',position);
    end    
else
    h = findobj('name',title_name);
    if isempty(h)
        if nargin == 1
            h = figure('name',title_name,'numbertitle','off');
        else
            h = figure('name',title_name,'numbertitle','off','position',position);
        end
    else
        figure(h);
    end
end
clf

if nargout
    fig = h;
end

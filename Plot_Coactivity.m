function Plot_Coactivity(coactivity,name,threshold,samples_per_second)
% Plot Coactivity
%
%       Plot_Coactivity(coactivity,name,threshold,samples_per_second)
%
% Perez-Ortega Jesus - March 2018
% Modified Nov 2018
% Modified May 2019

switch (nargin)
    case 1
        name = '';
        threshold = [];
        samples_per_second = 1;
    case 2
        threshold = [];
        samples_per_second = 1;
    case 3
        samples_per_second = 1;
end

fig = findobj('name',['Raster (' name ')']);
if isempty(fig)
    Set_Figure(['Coactivity (' name ')'], [0 0 1220 230]);
    ax = Set_Axes(['CoactiveAxes' name],[0 0 1 1]);
else
    figure(fig);
    ax = Hold_Axes(['CoactiveAxes' name]);
    if isempty(ax)
        ax = Set_Axes(['CoactiveAxes' name],[0 0 1 0.34]);
    else
        cla;
    end
end
F = length(coactivity);

plot(ax,coactivity,'k'); hold on

if ~isempty(threshold)
    plot(ax,[1 F],[threshold threshold],'--','color',[0.5 0.5 0.5],'lineWidth',2)
end

set(ax,'tag',['CoactiveAxes' name])

ylabel('coactivity')
ylim([min(coactivity(3:end-2)) max(coactivity(3:end-2))])
xlim([0 F])

Set_Label_Time(F,samples_per_second)

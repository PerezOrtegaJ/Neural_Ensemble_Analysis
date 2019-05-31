function Plot_Peaks_On_Coactivity(coactivity,peak_indices,group_indices,noise_group,...
    plot_peak_number,group_colors,width)
% Plot Peaks
%
%       Plot_Peaks_On_Coactivity(coactivity,peak_indices,group_indices,noise_group,...
%   plot_peak_number,group_colors,width)
%
% P�rez-Ortega Jes�s - March 2018
% modified May 2019

n = max(group_indices);
switch(nargin)
    case 5
        plot_peak_number = false;
        width = 1;
        group_colors = Read_Colors(n);
    case 6
        width = 1;
        group_colors = Read_Colors(n);
    case 7
        width = 1;
end

F = length(peak_indices);
peaks = max(peak_indices);
for i = 1:peaks
    peak = find(peak_indices==i);
    group = group_indices(i);
    if ~ismember(group,noise_group)
        x = peak(1)-width:peak(end)+width;
        x(x<=0) = [];
        x(x>=F) = [];
        plot(x,coactivity(x),'-','color',group_colors(group,:),'linewidth',1.5)
        if plot_peak_number
            max_peak = max(coactivity(x));
            text(peak(1),max_peak,num2str(i))
        end
    end
end
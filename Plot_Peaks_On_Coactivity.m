function Plot_Peaks_On_Coactivity(coactivity,peak_indices,sequence,noise_group,...
    plot_peak_number,colors,width)
% Plot Peaks
%
%       Plot_Peaks_On_Coactivity(coactivity,peak_indices,group_indices,noise_group,...
%   plot_peak_number,group_colors,width)
%
% Pérez-Ortega Jesús - March 2018
% modified May 2019
% modified Feb 2020

n = max(sequence);
switch(nargin)
    case 5
        plot_peak_number = false;
        width = 1;
        colors = Read_Colors(n);
    case 6
        width = 1;
        colors = Read_Colors(n);
    case 7
        width = 1;
end

F = length(peak_indices);
peaks = max(peak_indices);


% Find vectors
%
for i = 1:peaks
    peak = find(peak_indices==i);
    group = sequence(i);
    if ~ismember(group,noise_group)
        x = peak(1)-width:peak(end)+width;
        x(x<=0) = [];
        x(x>=F) = [];
        
        if length(x)==1
            plot(x,coactivity(x),'.','color',colors(group,:),'markersize',10)
        else
            plot(x,coactivity(x),'-','color',colors(group,:),'linewidth',1.5)
        end
        
        if plot_peak_number
            max_peak = max(coactivity(x));
            text(peak(1),max_peak,num2str(i))
        end
    end
end
%}

% rethinking
%{
id = find(peak_indices>0);
ensembles = unique(sequence)';
for i = ensembles
    % Create binary signal to identify the lenght of each activation
    x = [];
    x(id(sequence==i)) = 1;
    x = logical(x);
    plot(find(x),coactivity(x),'.','color',colors(i,:),'markersize',10)
end

%}
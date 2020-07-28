function Plot_Ensembles_Duration_Histogram(widths,fps,name,colors)
% Plot the histogram of the duration of each ensemble given the durations
%
%       Plot_Ensembles_Duration_Histogram(widths,fps,name,colors)
%
% By Jesus Perez-Ortega, May 2020

switch nargin
    case 2
        name = '';
        colors = [];
    case 3
        colors = [];
end

% Get number of ensambles
nEnsembles = length(widths);

% Get colors
if isempty(colors)
    colors = Read_Colors(nEnsembles);
end

Set_Figure(['Ensemble length - ' name],[0 0 1200 200])
maxH = 0;
for i = 1:nEnsembles
    % Get widths in seconds
    w = widths{i};
    
    % Plot histogram
    subplot(1,nEnsembles,i)
    h = histogram(w,'BinWidth',1,'FaceColor',colors(i,:));
    maxH = max([maxH h.BinLimits(2)]);
    
    % Display the average width
    title(sprintf('%.2f±%.2f s (%d peaks, %.2f s)',mean(w)/fps,std(w)/fps,length(w),sum(w)/fps))
    
    if i==1
        ylabel({'Count of';'ensemble activations'})
    end
end

% Set same maximum x limit
for i = 1:nEnsembles
    subplot(1,nEnsembles,i)
    Set_Label_Time(maxH,fps)
    xlim([0 maxH])
    label = get(gca,'xlabel');
    label = label.String;
    label = label(find(label=='('):end);
    xlabel(['Duration ' label])
end



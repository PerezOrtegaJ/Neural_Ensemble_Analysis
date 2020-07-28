function widths = Plot_Ensembles_Length(indices,sequence,name,fps)
% Identify the legnth of the ensembles and plot the distribution of each one
%
%       widths = Plot_Ensembles_Length(indices,sequence,name,fps)
%
% By Jesus Perez-Ortega, Feb 2020

% Find vectors
id = find(indices>0);

% Get the ensemble id
ensembles = unique(sequence)';
nEns = length(ensembles);

% Get colors
colors = Read_Colors(max(ensembles));

Set_Figure(['Ensemble length - ' name],[0 0 1200 200])
maxH = 0;
for i = 1:nEns
    seqEns = [];
    
    % Create binary signal to identify the lenght of each activation
    seqEns(id(sequence==ensembles(i))) = 1;
    [~,w] = Find_Peaks_Or_Valleys(seqEns);
    nPeaks = length(w);
    
    % Plot histogram
    subplot(1,max(ensembles),ensembles(i))
    h = histogram(w,'BinWidth',1,'FaceColor',colors(ensembles(i),:));
    y = h.Values;
    maxH = max([maxH h.BinLimits(2)]);
    
    % Display the average width
    title([num2str(nPeaks) ' (' num2str(mean(w)/fps,'%.2f') '±' num2str(std(w)/fps,'%.2f') ' s)'])
    widths{ensembles(i)} = w;
    
    if i==1
        ylabel({'Count of';'ensemble activations'})
    end
end

% Set same maximum x limit
for i = ensembles
    subplot(1,max(ensembles),i)
    Set_Label_Time(maxH,fps)
    xlim([0 maxH])
    label = get(gca,'xlabel');
    xlabel(['Length ' label.String])
end



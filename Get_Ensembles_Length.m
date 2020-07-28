function [widths,nPeaks] = Get_Ensembles_Length(indices,sequence)
% Identify the legnth of the ensembles and plot the distribution of each one
%
%       widths = Plot_Ensembles_Length(indices,sequence)
%
% By Jesus Perez-Ortega, Apr 2020

% Find vectors
id = find(indices>0);

% Get the ensemble id
ensembles = unique(sequence)';
nEns = length(ensembles);

% Get colors
for i = 1:nEns
    seqEns = [];
    
    % Create binary signal to identify the lenght of each activation
    seqEns(id(sequence==ensembles(i))) = 1;
    
    % find peaks
    [~,w] = Find_Peaks_Or_Valleys(seqEns);
    
    % get number of peaks
    nPeaks(i) = length(w);
    
    % assign widths
    widths{ensembles(i)} = w;
end



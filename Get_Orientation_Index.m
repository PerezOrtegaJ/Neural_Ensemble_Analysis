function [oi,p,orientation,mean_stim,sem_stim] = Get_Orientation_Index(raster,stimulus,degrees)
% Get the the orientation index of a neuron. The values ranges between 0-1
%
%       [oi,p,orientation,mean_stim,sem_stim] = Get_Orientation_Index(raster,stimulus,degrees)
%
% circular variance (Ringach et al., 2002)
% selectivity = 1 - circular variance
%
% Jesus Perez-Ortega May 2019

%% Get the count of spikes at each trial from each stimulus
angles = []; spikes = [];
n_stims = max(stimulus);
for i = 1:n_stims
    % Get indices from each stimulus
    during = stimulus==i;
    indices = Find_Peaks_Or_Valleys(during,0.5,true,true);
    
    % Get the sum of spikes at each trial
    spikes_i = Get_Peak_Vectors(raster,indices,'sum')';
    count = size(spikes_i,2);
    
    % Concatenate vectors
    spikes = [spikes spikes_i];
    
    % Get the angle
    angles = [angles; repmat(degrees(i),count,1)];
    
    % Get mean spikes per stimulus and sem
    mean_stim(:,i) = mean(spikes_i');
    sem_stim(:,i) = std(spikes_i')/sqrt(count);
end

%% Compute selectivity of each cell
% Get the exponential values
exps = exp(angles.*2*pi/180*1i);

% Get the number of cells
n_cells = size(spikes,1);
for i = 1:n_cells
    % Compute selectivity
    cell_spikes = sum(spikes(i,:));
    if cell_spikes
        points = spikes(i,:).*exps';
        [p(i), h1(i)] = Hotelling_T2_Test([real(points);imag(points)]',0.05);
        oi(i) = abs(sum(points))/cell_spikes;
    else
        p(i) = 1;
        h1(i) = false;
        oi(i) = 0;
    end
end

%% Identify the significant orientation
orientation = nan(1,n_cells);
[~,selective_stim] = max(mean_stim');
orientation(h1) = selective_stim(h1);

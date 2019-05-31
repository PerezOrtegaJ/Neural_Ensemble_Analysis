function Plot_Raster_By_Stimulus(raster,stimulus,before_samples,after_samples,locomotion,fps,save)

% Get size of the raster
max_data = max(raster(:));

% Get number of stimulus
n_stims = max(stimulus);

% Plot raster for each kind of stimulus
for i = 1:n_stims
    title_name = ['stimulus ' num2str(i)];

    % Get indices from each stimulus
    id = Get_Indices_Before_And_After_Stimulus(stimulus==i,before_samples,after_samples);
    
    % Plot raster
    Plot_Raster_Motion_Stimulus(raster(:,id),title_name,locomotion(id),stimulus(id),fps,max_data)
    
    % Save Figure
    if save
        Save_Figure(title_name,'png') 
    end
end
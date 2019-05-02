% Build a raster from Multi-Electrode Array (MEA)
%
% Read channels from the workspace. Each variable is a matrix with 79
% columns. The 2nd column indicate the unit and the 3rd column indicate the
% time stamp.
% 
% Pérez-Ortega Jesús - March 2018

function raster = Get_Raster_From_MEA_Channels(window_ms)
    if(nargin==0)
        window_ms=1;
    end
    
    channel_names=evalin('base','who');
    n_channels=length(channel_names);
    
    % Get the time length of the raster
    max_time=0;
    for i=1:n_channels
        max_i=evalin('base',['max(' channel_names{i} '(:,3));']);
        if(max_i>max_time)
            max_time=max_i;
        end
    end
    max_time=ceil(max_time)*1000;
    
    % Set raster size
    raster=zeros(1,max_time);
    
    % Build raster
    k=1;
    for i=1:n_channels
        channel=evalin('base',[channel_names{i} ';']);
        n_units=max(channel(:,2));
        for j=1:n_units
            time_stamps_unit=channel(channel(:,2)==j,3);
            spikes_id=round(time_stamps_unit*1000/window_ms)+1;
            if ~isnan(spikes_id)
                raster(k,spikes_id)=1;
            end
            k=k+1;
        end
    end
end
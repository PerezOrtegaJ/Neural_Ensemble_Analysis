% Build a raster from Multi-Electrode Array (MEA)
%
% Each variable is a matrix with 79
% columns. The 2nd column indicate the unit and the 3rd column indicate the
% time stamp.
% 
% Pérez-Ortega Jesús - Sep 2018

function raster = Get_Raster_From_MEA(channel_data,window_ms,omit)
    if(nargin==1)
        window_ms=1;
        omit=[];
    elseif(nargin==2)
        omit=[];
    end
    
    n_channels=unique(channel_data(:,1))';
    
    % Get the time length of the raster
    max_time=ceil(max(channel_data(:,3)))*1000;
    
    % Set raster size
    raster=zeros(1,max_time);
    
    % Build raster
    k=1;
    for i=n_channels
        if(~ismember(i,omit))
            channel=channel_data(channel_data(:,1)==i,:);
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
end
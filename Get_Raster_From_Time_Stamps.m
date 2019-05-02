% Convert raw data (time stamps in seconds) to raster
%
% Time stamps have to be in the workspace, and window defines the bin of the raster.
%
% By Jesús Pérez-Ortega July-2018

function raster=Get_Raster_From_Time_Stamps(window,initial_time,final_time)

    if(nargin==1)
        partial=false;
    elseif(nargin==3)
        partial=true;
    end
    
    unit_names=evalin('base','who');
    n_cells=length(unit_names);
    
    if (partial)
        max_time=ceil((final_time-initial_time)*1000/window);
    else
        % detect length of raster
        max_time=0;
        for cell=1:n_cells
            data_cell=evalin('base',unit_names{cell});
            max_cell=max(data_cell);
            if (max_cell>max_time)
                max_time=max_cell;
            end
        end
        max_time=ceil(max_time*1000/window);
    end
    
    % Define raster size
    raster=zeros(n_cells,max_time);

    % Fill the raster
    for cell=1:n_cells
        data_cell=evalin('base',unit_names{cell});
        spikes=round(data_cell*1000/window)+1;
        if ~isnan(spikes)
            if(partial)
                spikes=spikes(spikes>=initial_time*1000/window);
                spikes=spikes(spikes<=final_time*1000/window);
                spikes=spikes-floor(initial_time*1000/window)+1;
            end
            raster(cell,spikes)=1;
        end
    end
end
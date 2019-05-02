% Get the raster without spurious activity (between trials)
%
% Pérez-Ortega Jesús - July 2018

function raster_corrected = Delete_Raster_Activity_Between_Trials(raster,offset,time,trials)

    trial_time=time+offset;
    offset=offset+1;
    idx=[];
    for i=1:trials
        idx=[idx (offset:trial_time)+trial_time*(i-1)];
    end
    raster_corrected=raster(:,idx);
    
end
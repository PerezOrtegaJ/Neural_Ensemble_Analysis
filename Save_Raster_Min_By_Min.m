% Save figures minute by minute from raster
%
% Pérez-Ortega Jesús - March 2018

function Save_Raster_Min_By_Min(data_name,samples_per_minute,initial_min,final_min)
    initial_min=initial_min+1;
    for i=initial_min:final_min
        Hold_Axes(['RasterAxes' data_name]);
        xlim([(i-1)*samples_per_minute+1 i*samples_per_minute])
        Hold_Axes(['CoactiveAxes' data_name]);
        xlim([(i-1)*60 i*60])
        
        % Configure and save image
        Save_Figure([data_name '_' num2str(i-1,'%.2i') '-' num2str(i,'%.2i') 'min']);
    end
end

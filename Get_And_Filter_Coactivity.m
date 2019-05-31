% Get Coactivity 
%
% double smoothing filter
%
% By Jesús Pérez-Ortega jan-2018
% modified feb-2018
% modified april-2018

function smooth_coactivity = Get_And_Filter_Coactivity(raster,bin)
    coactivity=sum(raster)';
    if(bin>1)
        % double smoothing
        smooth_coactivity=smooth(coactivity,bin);
        smooth_coactivity=smooth(smooth_coactivity,bin);
    else
        smooth_coactivity=coactivity;
    end
end
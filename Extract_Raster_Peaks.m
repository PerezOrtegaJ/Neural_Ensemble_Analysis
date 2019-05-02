% Extract raster peaks from raster
%
% Variable is raster_analysis by ensembles 
%
% Pérez-Ortega Jesús, Nov 2018

function raster_peaks = Extract_Raster_Peaks(raster_analysis, range, peaks)
    switch(nargin)
        case 1
            id = find(raster_analysis.Peaks.Indices > 0);
        case 2
            id = find(raster_analysis.Peaks.Indices(range) > 0)+range(1)-1;
        case 3
            if(peaks)
                id = find(raster_analysis.Peaks.Indices(range) > 0)+range(1)-1;
            else
                id = find(raster_analysis.Peaks.Indices(range) == 0)+range(1)-1;
            end
    end
    raster_peaks = raster_analysis.Raster.Raster(:,id);
end
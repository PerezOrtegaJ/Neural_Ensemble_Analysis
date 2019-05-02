% Get z-score of spike rate from raster
% 
% By Jesús Pérez-Ortega aug-2018

function spike_rate = Get_Zscore_From_Raster(raster,bin,step)
    
    [c,f]=size(raster);
    
    spike_rate=zeros([c f]);
    for i=1:c
        % Get frequencies
        spike_rate(i,:)=Get_Spike_Rate(raster(i,:),bin,step);

        % z-score
        spike_rate(i,:)=spike_rate(i,:)-mean(spike_rate(i,:));
        if(std(spike_rate(i,:)))
            spike_rate(i,:)=spike_rate(i,:)/std(spike_rate(i,:));
        end
    end
end
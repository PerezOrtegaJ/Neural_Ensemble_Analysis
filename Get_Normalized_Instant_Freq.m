% Get Normalized Instantaneous Frequency from raster
% 
% Instantaneous frequency = inverse of ISI
% 
% By Jesús Pérez-Ortega jan-2018
% modified feb-2018
% modified jan-2019

function freqs = Get_Normalized_Instant_Freq(data,fps,norm_type,bin)
    
    if(nargin==3)
        bin=0;
    end

    [c,f]=size(data);
    freqs=zeros([c f]);
    for i=1:c
        % Get frequencies
        freqs(i,:)=Get_Instant_Freq(data(i,:),fps);

        if(~freqs(i,:))
            freqs(i,:)=zeros(1,f);
        else
            % Normalize the firing frequency
            if (bin)
                freqs(i,:)=smooth(freqs(i,:),bin);
            end
            if (~strcmp(norm_type,'none'))
                freqs(i,:)=freqs(i,:)-mean(freqs(i,:));
                switch(norm_type)
                    case 'norm'
                        freqs(i,:)=freqs(i,:)/max(freqs(i,:)); % Normalize
                    case 'zscore'
                        freqs(i,:)=freqs(i,:)/std(freqs(i,:)); % Z-score
                end
            end
        end
    end
end
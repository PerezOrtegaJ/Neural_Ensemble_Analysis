% Get z-score of spike rate of a single neuron
% 
% By Jesús Pérez-Ortega aug-2018

function spike_rate = Get_Spike_Rate(spikes,bin,step)
    n=length(spikes);
    n_sum=floor((n-bin)/step+1);
    
    spike_rate=zeros(1,n);
    for i=1:n_sum
        % Get spike rate
        ini=(i-1)*step+1;
        fin=(i-1)*step+bin;
        spike_rate(ini:(ini+step-1))=sum(spikes(ini:fin));
    end
    spike_rate = spike_rate(1:n);
end
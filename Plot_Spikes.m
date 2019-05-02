% Plot spikes
%
% Jesús Pérez-Ortega, Nov 2018

function Plot_Spikes(spikes,value,color)
    switch(nargin)
        case 1
            color = [0 0 0];
            value = 1;
        case 2
            color = [0 0 0];
    end

    samples = length(spikes);

    id = find(spikes);
    n_spikes = length(id);
    
    time=repmat(id',1,2);
    
    spikes_1=ones(n_spikes,1)*value-1;
    spikes_2=ones(n_spikes,1)*value;
    spikes=[spikes_1 spikes_2];
    
    plot(time',spikes','color',color)
    if(samples<1000)
        label = [num2str(samples) ' ms'];
    elseif(samples<=60000)
        label = [num2str(samples/1000) ' s'];
    else
        label = [num2str(samples/60000) ' min'];
    end
        
    set(gca,'ytick',[],'xtick',[0 samples],'xticklabel',{'0',label})
end
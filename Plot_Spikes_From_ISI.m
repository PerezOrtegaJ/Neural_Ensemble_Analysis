% Plot spikes from ISI
%
% Jesús Pérez-Ortega, Nov 2018

function Plot_Spikes_From_ISI(isi)

    n_spikes = length(isi);
    
    % Get spikes from ISI
    if(size(isi,2)==1)
        time=repmat(cumsum(isi),1,2);
    else
        time=repmat(cumsum(isi)',1,2);
    end

    spikes_1=zeros(n_spikes,1);
    spikes_2=ones(n_spikes,1);
    spikes=[spikes_1 spikes_2];
    
    plot(time',spikes','k')
%     title(['Spikes = ' num2str(n_spikes)])
%     xlabel('time [s]')
    set(gca,'ytick',[])
end
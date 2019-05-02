% Plot change in each neuron activity
%
% Jesús Pérez-Ortega, nov 2018

function Plot_Changes_In_Neurons(change,change_title,name)
    if(nargin==2)
        name='';
    end
    n_neurons=length(change);
    plot(find(change>0),change(change>0),'.r','markersize',10); hold on
    plot(find(change==0),change(change==0),'.k','markersize',10)
    plot(find(change<0),change(change<0),'.b','markersize',10)
    plot([0 n_neurons],[mean(change) mean(change)],'--k','markersize',10)
    title(name)
    xlabel('neuron'); ylabel(change_title)
    xlim([1 n_neurons]); %ylim([-7000 7000])
    view([90 90]);
    set(gca,'xdir','reverse')
end
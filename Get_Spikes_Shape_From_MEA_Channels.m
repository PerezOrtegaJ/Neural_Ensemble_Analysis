% Get the spikes shape from Multi-Electrode Array (MEA)
%
% Read channels from the workspace. Each variable is a matrix with 79
% columns. The shape of the spikes is from 4-79 to thecolumn indicate the unit and the 3rd column indicate the
% time stamp.
% 
% Pérez-Ortega Jesús - March 2018

function [mean_shapes min_shapes max_shapes] = Get_Spikes_Shape_From_MEA_Channels(plot_save)
    if(nargin==0)
        plot_save=1;
    end
    
    channel_names=evalin('base','who');
    n_channels=length(channel_names);
    
    % Build raster
    if(plot_save)
        Set_Figure('Spikes shape',[0 0 1000 800]);
    end
    
    k=1;
    for i=1:n_channels
        channel=evalin('base',[channel_names{i} ';']);
        n_units=max(channel(:,2));
        for j=1:n_units
            spikes_shape=channel(channel(:,2)==j,4:end);
            max_shapes(k,:)=max(spikes_shape);
            min_shapes(k,:)=min(spikes_shape);
            mean_shapes(k,:)=mean(spikes_shape);
       
            if(plot_save)
                subplot(5,6,k)
                mins=min_shapes(k,:);
                maxs=max_shapes(k,:)-mins;

                h=area([mins;maxs]',-10000,'LineStyle',':'); hold on
                set(h(2),'FaceColor', [0.9 0.9 1])
                set(h(1),'FaceColor', [1 1 1])

                plot(mean_shapes(k,:),'b')
                ylim([min(mins) -min(mins)])
                title(['Channel ' num2str(i) ' - unit ' num2str(j)])
                
                if(~mod(k+5,6))
                    ylabel('Amplitude (mV)')
                end
            end
            k=k+1;
        end
    end
end
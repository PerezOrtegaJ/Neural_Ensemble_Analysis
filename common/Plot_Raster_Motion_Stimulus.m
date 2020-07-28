function Plot_Raster_Motion_Stimulus(raster,name,locomotion,stimulus,fps,max_data)
% Plot raster, coactivity, moyion and the stimulus
%
%       Plot_Raster_Motion_Stimulus(data,name,locomotion,stimulus,fps)
%
% Perez-Ortega Jesus - May 2018

if nargin == 5
    max_data = max(raster(:));
end

[n_cells,n_frames] = size(raster);

if n_cells == 1
    Set_Figure(name,[0 0 1200 300]);
    subplot(3,1,1)
    Plot_Raster(raster,name,true,false,false)
    set(gca,'xtick',[],'clim',[0 max_data])
    ylabel('neuron #')

    subplot(3,1,2)
    plot(stimulus,'k')
    set(gca,'xtick',[],'ytick',[])
    ylabel('stimulus')
    xlim([0 n_frames])

    subplot(3,1,3)
    plot(locomotion,'k')
    set(gca,'xtick',[],'ytick',[])
    ylabel('motion')
    xlim([0 n_frames])
    Set_Label_Time(n_frames,fps)
else
    Set_Figure(name,[0 0 1200 700]);
    subplot(8,1,1:5)
    Plot_Raster(raster,name,true,false,false)
    set(gca,'xtick',[],'clim',[0 max_data])
    ylabel('neuron #')

    subplot(8,1,6)
    plot(sum(raster),'k')
    set(gca,'xtick',[])
    xlim([0 n_frames])
    ylabel('coactivity')

    subplot(8,1,7)
    plot(stimulus,'k')
    set(gca,'xtick',[],'ytick',[])
    ylabel('stimulus')
    xlim([0 n_frames])

    subplot(8,1,8)
    plot(locomotion,'k')
    set(gca,'xtick',[],'ytick',[])
    ylabel('motion')
    xlim([0 n_frames])
    Set_Label_Time(n_frames,fps)
end
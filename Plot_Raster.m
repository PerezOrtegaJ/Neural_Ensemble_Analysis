function Plot_Raster(data,name,spikes,reshape,create_figure)
% Plot Raster
%
%       Plot_Raster(data,name,spikes,reshape,create_figure)
%
% Pérez-Ortega Jesús 2018
% modified Nov 2018
% modified Mar 2019
% modified May 2019

switch nargin
    case 1
        name='';
        spikes = true;
        reshape = true;   
        create_figure = true;
    case 2
        spikes = true;
        reshape = true;    
        create_figure = true;
    case 3
        reshape = true;    
        create_figure = true;
    case 4
        create_figure = true;
end

% Get size of the raster
[C,F] = size(data);

% Create a new figure
if create_figure
    Set_Figure(['Raster (' name ')'],[0 0 1220 460]);
    Set_Axes(['RasterAxes' name],[0 0.34 1 0.66]);
end
axis([0 F 0.5 C+0.5]); hold on

% Plot raster
if spikes
    if reshape>1
        win = reshape;
    elseif reshape
        if F<6001
            win = 1;
        elseif F<20001
            win = 10;
        elseif F<500001
            win = 20;
        else
            win = 50;
        end
    else
        win = 1;
    end

    if sum(data(:,1))>floor(sum(data(:,1)))
        imagesc(data,[0 max(data(:))]); colormap(flipud(gray))
    else
        data = Reshape_Raster(data,win); xlim([0 F/win])
        imagesc(data,[0,1]); colormap([1 1 1; 0 0 0])
    end
else
    imagesc(data,[-4 4]); Set_Colormap_Blue_White_Red();
end
box on
set(gca,'XTicklabel','','XTick',[0 C])
title(strrep(name,'_','-'))
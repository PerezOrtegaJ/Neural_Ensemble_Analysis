% Plot Raster
%
% Pérez-Ortega Jesús 2018
% modified Nov 2018
% modified Mar 2019
function Plot_Raster(data,name,spikes,reshape)
    switch(nargin)
        case 1
            name='';
            spikes = true;
            reshape = true;    
        case 2
            spikes = true;
            reshape = true;    
        case 3
            reshape = true;    
    end
    
    [C,F]=size(data);
    Set_Figure(['Raster (' name ')'],[0 0 1220 460]);
    Set_Axes(['RasterAxes' name],[0 0.34 1 0.66]);
    axis([0 F 0.5 C+0.5]); box; hold on
    if(spikes)
        if(reshape)
            if(F<6001)
                win = 1;
            elseif(F<20001)
                win = 10;
            elseif(F<100001)
                win = 20;
            else
                win = 50;
            end
        else
            win = 1;
        end
        
        if(sum(data(:,1))>floor(sum(data(:,1))))
            imagesc(data); colormap(flipud(gray))
        else
            data = Reshape_Raster(data,win); xlim([0 F/win])
            imagesc(data,[0,1]); colormap([1 1 1; 0 0 0])
        end
    else
%         data=data>0;
%         imagesc(data,[0,1]); colormap([1 1 1; 0.8 0 0])
%         imagesc(data,[-0.2,0.2]); Set_Colormap_Blue_White_Red();
        imagesc(data,[-4 4]); Set_Colormap_Blue_White_Red();
    end
    set(gca,'XTicklabel','','XTick',[0 C])
    title(strrep(name,'_','-'))
end
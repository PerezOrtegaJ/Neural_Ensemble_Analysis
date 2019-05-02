% Plot Coactivity
%
% P?rez-Ortega Jes?s - March 2018
% Modified Nov 2018
function Plot_Coactivity(coactivity,name,threshold,samples_per_second)
    if(nargin==1)
        name = '';
        threshold = [];
        samples_per_second = 1;
    elseif(nargin==2)
        threshold = [];
        samples_per_second = 1;
    elseif(nargin==3)
        samples_per_second = 1;
    end
    
    h=findobj('name',['Raster (' name ')']);
    if isempty(h)
        Set_Figure(['Coactivity (' name ')'], [0 0 1220 230]);
        Set_Axes(['CoactiveAxes' name],[0 0 1 1]);
    else
        figure(h);
        h=Hold_Axes(['CoactiveAxes' name]);
        if(isempty(h))
            Set_Axes(['CoactiveAxes' name],[0 0 1 0.34]);
        else
            cla;
        end
    end
    F=length(coactivity);
   
    plot((1:F)/samples_per_second,coactivity,'k');hold on
    ylabel('coactivity'); ylim([min(coactivity(3:end-2)) max(coactivity(3:end-2))])
    
    if(~isempty(threshold))
        plot([1 F]/samples_per_second,[threshold threshold],'--','color',[0.5 0.5 0.5],'lineWidth',2)
    end
    
    if(F/samples_per_second<30)
        set(gca,'box','off','xtick',0:F/samples_per_second,'tag',['CoactiveAxes' name])
        xlabel('Time (s)'); 
    elseif(F/samples_per_second/60<3)
        set(gca,'box','off','xtick',0:10:F/samples_per_second,'tag',['CoactiveAxes' name])
        xlabel('Time (s)'); 
    else
        set(gca,'box','off','xtick',0:60:F/samples_per_second,'xticklabel',0:F/samples_per_second/60,'tag',['CoactiveAxes' name])
        xlabel('Time (min)'); 
    end
    
    xlim([0 F/samples_per_second])
    
%     ylims=get(gca,'ylim');
%     if(ylims(1)<0)
%         ylim([0 ylims(2)]) 
%     end
end
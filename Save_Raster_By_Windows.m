% Save figures second by second from raster
%
% Pérez-Ortega Jesús - May 2018

function Save_Raster_By_Windows(name,samples_per_second,window_sec,final_sec)

    Hold_Axes(['CoactiveAxes' name]);
    set(gca,'xtick',0:window_sec:final_sec)
    set(gca,'xticklabel',0:window_sec:final_sec)
    xlabel('time (s)')
    for i=1:window_sec:final_sec
        Hold_Axes(['RasterAxes' name]);
        xlim([i-1 i+window_sec-1]*samples_per_second)
        Hold_Axes(['CoactiveAxes' name]);
        xlim([i-1 i+window_sec-1])
        
        % Configure and save image
        Save_Figure([name '_' num2str(i-1,'%.2f') '-' num2str(i+window_sec-1,'%.2f') 'sec']);
    end
end

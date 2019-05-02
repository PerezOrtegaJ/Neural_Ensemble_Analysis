% Get Z-score of coactivity with an specific time window
%
%
% By Jes?s P?rez-Ortega jan-2018
% modified april-2018
% modified august-2018

function z_score_coactivity = Z_Score_Coactivity(coactivity,zscore_window,only_mean)
    if(nargin<2)
        zscore_window=length(coactivity);
        only_mean=false;
    end
    
    if(zscore_window==0)
        zscore_window=length(coactivity);
    end

    z_score_coactivity=zeros(size(coactivity));
    F=length(coactivity);
    if(F>zscore_window)
        n_final=round(F/zscore_window);
        for i=1:n_final
            inicio=zscore_window*(i-1)+1;
            fin=inicio+zscore_window-1;
            if(fin>F)
                fin=F;
            end
            if(only_mean)
                z_score_coactivity(inicio:fin)=coactivity(inicio:fin)-mean(coactivity(inicio:fin));
            else
                z_score_coactivity(inicio:fin)=(coactivity(inicio:fin)-mean(coactivity(inicio:fin)))/std(coactivity(inicio:fin));
            end
        end
        n_Smooth=length(z_score_coactivity);
        if(fin<n_Smooth)
            inicio=fin+1;
            fin=n_Smooth;
            if(only_mean)
                z_score_coactivity(inicio:fin)=coactivity(inicio:fin)-mean(coactivity(inicio:fin));
            else
                z_score_coactivity(inicio:fin)=(coactivity(inicio:fin)-mean(coactivity(inicio:fin)))/std(coactivity(inicio:fin));
            end            
        end
    else
        if(only_mean)
            z_score_coactivity=coactivity-mean(coactivity);
        else
            z_score_coactivity=(coactivity-mean(coactivity))/std(coactivity);
        end
    end
end
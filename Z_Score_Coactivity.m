function zscoreCoactivity = Z_Score_Coactivity(coactivity,zscoreWindow,onlyAvg)
% Get Z-score of coactivity with an specific time window
%
%       zscoreCoactivity = Z_Score_Coactivity(coactivity,zscoreWindow,onlyAvg)
%
%       zscoreWindow, compute z-score by windows
%       onlyAvg, do the average substraction but not the standard deviation
%       division
%
%       default: zscoreWindow = length(coactivity); onlyMean = false
%
% By Jesus Perez-Ortega jan-2018
% modified april-2018
% modified august-2018
% modified Apr 2020 (cleaning code)

if nargin == 1
    zscoreWindow = length(coactivity);
    onlyAvg = false;
end

if zscoreWindow==0
    zscoreWindow = length(coactivity);
end

zscoreCoactivity = zeros(size(coactivity));
F = length(coactivity);

if F>zscoreWindow
    n_final = round(F/zscoreWindow);
    for i = 1:n_final
        inicio = zscoreWindow*(i-1)+1;
        fin = inicio+zscoreWindow-1;
        if fin>F
            fin = F;
        end
        
        if onlyAvg
            zscoreCoactivity(inicio:fin) = coactivity(inicio:fin)-mean(coactivity(inicio:fin));
        else
            zscoreCoactivity(inicio:fin) = (coactivity(inicio:fin)-mean(coactivity(inicio:fin)))...
                /std(coactivity(inicio:fin));
        end
    end
    
    nSmooth = length(zscoreCoactivity);
    if fin<nSmooth
        inicio = fin+1;
        fin = nSmooth;
        if onlyAvg
            zscoreCoactivity(inicio:fin) = coactivity(inicio:fin)-mean(coactivity(inicio:fin));
        else
            zscoreCoactivity(inicio:fin) = (coactivity(inicio:fin)-mean(coactivity(inicio:fin)))...
                /std(coactivity(inicio:fin));
        end            
    end
else
    if onlyAvg
        zscoreCoactivity = coactivity-mean(coactivity);
    else
        zscoreCoactivity = (coactivity-mean(coactivity))/std(coactivity);
    end
end
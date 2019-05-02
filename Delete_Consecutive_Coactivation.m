% Delete consecutive coactivation patterns from raster
%
% By Jesús E. Pérez-Ortega Aug-2018

function [short_raster indices]= Delete_Consecutive_Coactivation(raster)
    same=squareform(pdist(double(raster'),'hamming'),'tomatrix')==0;
    d=diff(same);
    j=1; indices=1;
    while(~isempty(j))
        idx=find(d(j:end,j)==-1,1,'first');
        j=j+idx;
        indices=[indices j];
    end
    short_raster=raster(:,indices);
end
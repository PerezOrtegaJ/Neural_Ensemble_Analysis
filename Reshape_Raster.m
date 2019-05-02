% Reshape raster
%
% Binarize the raster by a given window
%
% Pérez-Ortega Jesús - May 2018

function new_raster=Reshape_Raster(raster,window)
    [c,n]=size(raster);

    if(window==1)
        new_raster = raster;
    else
        new_n=floor(n/window);
        new_raster=zeros(c,new_n);
        for i=1:new_n
            ini=(i-1)*window+1;
            fin=i*window;
            new_raster(:,i)=logical(sum(raster(:,ini:fin),2));
        end
    end
end
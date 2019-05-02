% Get adjacency matrix from raster peaks
%
% Negative numbers and NaNs are set to 0s
%
% Pérez-Ortega Jesús - march 2018
% Modified - may 2018
% Modified - june 2018

function adjacency=Get_Adjacency_From_Raster(raster,connectivity_method)
    cells=size(raster,1);
    switch(connectivity_method)
        case 'coactivity'
            %warning('Data is set to binary to obtain the adjacency matrix.')
            raster=double(raster>0);
            adjacency=raster*raster'.*(1-eye(cells));            
        case 'jaccard'
            %warning('Data is set to binary to obtain the adjacency matrix.')
            raster=double(raster>0);
            adjacency=squareform(1-pdist(raster,'jaccard'));
            adjacency(isnan(adjacency))=0;
        otherwise
            adjacency=corr(raster','type',connectivity_method);
            adjacency(adjacency<0)=0;
            adjacency(isnan(adjacency))=0;
            adjacency=adjacency.*(ones(cells)-eye(cells));
    end
end    
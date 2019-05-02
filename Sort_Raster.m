function [sorted,sorted_id] = Sort_Raster(raster,direction)
% Sort raster
%
%   [sorted,sorted_id] = Sort_Raster(raster,direction)
%
% Jesús Pérez-Ortega - Dic 2018
% Modified Jan 2019

    if(nargin==1)
        direction = 'descend';
    end
    
    sorted = raster;
    sorted_id = 1:size(raster,1);
    n_seq = size(sorted,2);
    for i = n_seq:-1:1
       [~,id] = sort(sorted(:,i),direction);
       sorted = sorted(id,:);
       sorted_id = sorted_id(id); 
    end
end
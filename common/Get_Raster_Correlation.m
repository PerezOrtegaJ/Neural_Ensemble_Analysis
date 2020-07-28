function correlation = Get_Raster_Correlation(raster,signal)
% Get correlation of each neuron from the raster to the signal
%
%           correlation = Get_Neurons_Correlation(raster,signal)
%
% By Jesus Perez-Ortega, August 2019

n = size(raster,1);
dist = zeros(1,n);
for i = 1:n
    dist(i) = pdist([signal;raster(i,:)],'correlation');
end
correlation = 1-dist;
correlation(isnan(correlation)) = 0;
correlation(correlation<0) = 0;
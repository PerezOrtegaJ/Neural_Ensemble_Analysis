function SEM = Get_SEM(data)
% get the standar error of the mean (SEM)
%
%       SEM = Get_SEM(data)
%
% By Jesus Perez-Ortega, MArch 2020

SEM = std(data)/sqrt(numel(data));

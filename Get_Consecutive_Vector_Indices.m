function vectorID = Get_Consecutive_Vector_Indices(samples,width)
% Get consecutive indices of specific width to create neuronal vectors
%
%       vectorID = Get_Consecutive_Vector_Indices(samples,width)
%
% By Jesus Perez-Ortega, Nov 2019

n = ceil(samples/width);
vectorID = zeros(samples,1);

for i = 1:n
    ini = (i-1)*width+1;
    fin = i*width;
    if fin>samples
        fin = samples;
    end
    vectorID(ini:fin) = i;
end
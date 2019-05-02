% Get Inter spike interval (ISI)
%
% inputs: data = vector with spikes (0: no spike, 1: spike)
%         f = samples per second (sampling frequency)
%
% By Jesús E. Pérez-Ortega - jan - 2019

function isi = Get_ISI(data,f)
    id = find(data);
    isi = diff(id)/f;
end
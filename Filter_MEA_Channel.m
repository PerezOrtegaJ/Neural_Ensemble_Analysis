% Filter MEA
% 
% Lab Peña-Ortega
% 250 - 7,500 Hz band pass filter
% butterworth order 2
%
% By Pérez-Ortega Jesús, jan-2019

function filtered = Filter_MEA_Channel(signal)

    fs = 25000; % sampling frequency
    
    % Filter design
    order=2;
    % low pass
    fc = 7500; % cutoff frequency
    [b,a] = butter(order,fc/(fs/2),'low');
    
    % Filter 1
    y = filter(b,a,signal);
    
    % high pass
    fc = 250; % cutoff frequency
    [b,a] = butter(order,fc/(fs/2),'high');
    
    % Filter 2
    filtered = filter(b,a,y);
end
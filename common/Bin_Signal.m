function binned = Bin_Signal(signal,step,type)
% Bin the signal given a given step and type from a logical signal. Each
% rise time will be taken to start the bin.
%
%       binned = Bin_Signal(signal,step,type)
%
% Perez-Ortega Jesus - May 2019

signal = double(signal);
switch type
    case 'single'
        if step == 0
            binned = (Find_Peaks_Or_Valleys(signal,0.5,true,true,0,1,true)>0)';
        elseif step<0
            binned = Find_Peaks_Or_Valleys(signal,0.5,true,true,0,step,true)>0;
            binned = (Find_Peaks_Or_Valleys(double(binned),0.5,true,true,0,1,true)>0)';
        else
            binned = Find_Peaks_Or_Valleys(signal,0.5,true,true,0,step,true)>0;
            binned = (Find_Peaks_Or_Valleys(double(binned),0.5,true,false,0,-1,true)>0)';
        end
    case 'after_onset'
        binned = (Find_Peaks_Or_Valleys(signal,0.5,true,true,0,step,true)>0)';
    case 'after'
        binned = (Find_Peaks_Or_Valleys(signal,0.5,true,false,0,step,true)>0)';
    case 'before'
        binned = (Find_Peaks_Or_Valleys(signal,0.5,true,true,0,-step,true)>0)';
end
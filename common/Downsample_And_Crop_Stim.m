function stim = Downsample_And_Crop_Stim(stimuli,period_ms,samples)
% Get the visual stimulus of the same length of the imaging
% 
% The signal should be recorded in ms, and period should be a integer
% number of ms.
%
%       stim = Downsample_And_Crop_Stim(stimuli,period_ms,samples)
%
% By Jesus Perez-Ortega, July 2019

stim = downsample(round(stimuli*2),period_ms);
stim = stim(1:samples);
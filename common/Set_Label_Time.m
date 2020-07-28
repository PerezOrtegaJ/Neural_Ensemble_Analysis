function Set_Label_Time(samples,sampleFrequency,sampleShift)
% Set convenient label of time
%
%   Set_Label_Time(samples,sampleFrequency)
%
% Jesus Perez-Ortega April-19
% Modified May 2019
% Modified Oct 2019
% Modified Nov 2019
% Modified Jul 2020

if nargin==2
    sampleShift = 0;
end

% Plot depending on the duration
if(samples/sampleFrequency<=1)          % Less than 1 s
    step = 0.1;
    xlabel('Time (ms)');
    factor = 0.001;
elseif(samples/sampleFrequency<=3)          % Less than 2 s
    step = 0.5;
    xlabel('Time (ms)');
    factor = 0.001;
elseif(samples/sampleFrequency<=15)     % Less than 10 s
    step = 1;
    xlabel('Time (s)');
    factor = 1;
elseif(samples/sampleFrequency<=30)      % Less than 30 s
    step = 5;
    xlabel('Time (s)');
    factor = 1;
elseif(samples/sampleFrequency/60<3)    % Less than 3 min
    step = 20;
    xlabel('Time (s)');
    factor = 1;
elseif(samples/sampleFrequency/60<30)   % Less than 30 min
    step = 60;
    xlabel('Time (min)');
    factor = 60;
elseif(samples/sampleFrequency/60<60)   % Less than 60 min
    step = 60*5;
    xlabel('Time (min)');
    factor = 60;
elseif(samples/sampleFrequency/60<180)  % Less than 180 min
    step = 60*30;
    xlabel('Time (min)');
    factor = 60;
else
    step = 60*60;
    xlabel('Time (h)');
    factor = 3600;
end

set(gca,'box','off','xtick',(1:step*sampleFrequency:(samples+1))+sampleShift,...
    'xticklabel',(0:samples/sampleFrequency/step)*step/factor)
xlim([1 samples+1])


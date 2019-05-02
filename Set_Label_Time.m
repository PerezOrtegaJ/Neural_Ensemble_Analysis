function Set_Label_Time(samples,sample_frequency)
% Set convenient label of time
%
%   Set_Label_Time(samples,sample_frequency)
%
% Jesus Perez-Ortega April-19

% less than 30 seconds
if(samples/sample_frequency<10)
    step = 1;
    xlabel('Time (s)'); 
elseif(samples/sample_frequency<30)
    step = 3;
    xlabel('Time (s)'); 
elseif(samples/sample_frequency/60<3)
    step = 10;
    xlabel('Time (s)'); 
elseif(samples/sample_frequency/60<60)
    step = 60;
    xlabel('Time (min)'); 
else
    step = 60*60;
    xlabel('Time (h)'); 
end

set(gca,'box','off','xtick',0:step*sample_frequency:samples,...
    'xticklabel',0:samples/sample_frequency/step)



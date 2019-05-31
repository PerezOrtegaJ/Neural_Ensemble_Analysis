function Set_Label_Time(samples,sample_frequency)
% Set convenient label of time
%
%   Set_Label_Time(samples,sample_frequency)
%
% Jesus Perez-Ortega April-19

% plot depending on the duration
if(samples/sample_frequency<10)
    step = 1;
    xlabel('Time (s)');
    factor = 1;
elseif(samples/sample_frequency<30)
    step = 3;
    xlabel('Time (s)'); 
    factor = 1;
elseif(samples/sample_frequency/60<3)
    step = 10;
    xlabel('Time (s)'); 
    factor = 1;
elseif(samples/sample_frequency/60<60)
    step = 60;
    xlabel('Time (min)'); 
    factor = 60;
elseif(samples/sample_frequency/60<180)
    step = 60*30;
    xlabel('Time (min)'); 
    factor = 60;
else
    step = 60*60;
    xlabel('Time (h)'); 
    factor = 3600;
end

set(gca,'box','off','xtick',0:step*sample_frequency:samples,...
    'xticklabel',(0:samples/sample_frequency/step)*step/factor)



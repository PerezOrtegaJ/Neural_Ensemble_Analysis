function Plot_Spikes(binary,value,color)
% Plot spikes
%
%       Plot_Spikes(binary,value,color)
%
%       default: value = 1; color = [0 0 0]
%
% Jesús Pérez-Ortega, Nov 2018
% Modified Jun 2020

switch(nargin)
    case 1
        color = [0 0 0];
        value = 1;
    case 2
        color = [0 0 0];
end

if iscolumn(binary)
    binary = binary';
end

samples = length(binary);
id = find(binary);
n_spikes = length(id);

time=repmat(id',1,2);

spikes_1 = ones(n_spikes,1)*value-1;
spikes_2 = ones(n_spikes,1)*value;
spikes = [spikes_1 spikes_2];

plot(time',spikes','color',color)
set(gca,'ytick',[],'xtick',[],'xlim',[0 samples])

%{
%% It is better to use Set_Label_Time()

if(samples<1000)
    label = [num2str(samples) ' ms'];
elseif(samples<=60000)
    label = [num2str(samples/1000) ' s'];
else
    label = [num2str(samples/60000) ' min'];
end
set(gca,'ytick',[],'xtick',[0 samples],'xticklabel',{'0',label})
%}


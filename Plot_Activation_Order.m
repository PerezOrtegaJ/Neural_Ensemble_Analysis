function [id_position,entropy,sequences_sorted] = Plot_Activation_Order(raster,network,window,...
    bin,colors,name,save)
% Plot activation order of neurons based on a network
%
% By Pérez-Ortega Jesús, Feb 2019

switch(nargin)
    case 2
        window = size(raster,2);
        bin = 1;
        colors = autumn(size(raster,1));
        name = '';
        save = false;
    case 3
        bin = 1;
        colors = autumn(size(raster,1));
        name = '';
        save = false;
    case 4
        colors = autumn(size(raster,1));
        name = '';
        save = false;
    case 5
        name = '';
        save = false;
    case 6
        save = false;
end

% Get sequences
n = size(raster,1);
%sequences = randperm(n);
sequences = zeros(n);

n_seqs = size(raster,2)/window;
for i = 1:n_seqs
    ini = (i - 1) * window + 1;
    fin = i * window;
    r = Reshape_Raster(raster(:,ini:fin),bin);
    sequence = Get_Network_Activation_Sequence(r,network);
    % get random seuqence of the resting spots
%     rest = n-length(sequence);
%     if rest>0
%         resting = setdiff(1:n,sequence);
%         resting = resting(randperm(rest));
%         sequence = [sequence resting];
%     end
    sequences(i,1:length(sequence)) = sequence;
end

% Identify activation position
[sequences_sorted,id_position,probabilities] = Sort_Activation_Position(sequences);

% Get entropy
for i = 1:n
    p = probabilities(:,i);
    entropy(i) = Get_Entropy(p);
end
% Normalize entropy
entropy = entropy/Get_Entropy(ones(1,n+1)); % with "neuron 0"
%entropy = entropy/Get_Entropy(ones(1,n)); % without "neuron 0"

Set_Figure(['Sequences - ' name],[0 0 500 800]);
ax=subplot(6,1,1:4);
imagesc(sequences_sorted); hold on
colormap(ax,[1 1 1;colors])% with "neuron 0"
%colormap(ax,colors) % without "neuron 0"
ylabel('sequence #')
title(name)
   
ax=subplot(6,1,5);
imagesc(probabilities(2:end,:),[0 0.5])
%set(gca,'ytick',[1 n+1],'yticklabel',[0 n])
colormap(ax,flipud(gray(100)))
ylabel('neuron #')

subplot(6,1,6)
plot(entropy,'o-','color',colors(1,:))
ylabel('entropy')
xlabel('activation order')
xlim([0.5 n+0.5])
ylim([0 1])
if(save)
    Save_Figure([name ' - activation order'])
end

% color neurons 
% Set_Figure(['Color neurons - ' name],[0 0 20 800]);
% imagesc((1:n)')
% set(gca,'xtick',[],'ytick',[])
% colormap(colors)
% for i = 1:n
%     text(1,i,num2str(i),'horizontalalignment','center')
% end
% if(save)
%     Save_Figure([name ' - color neurons'])
% end
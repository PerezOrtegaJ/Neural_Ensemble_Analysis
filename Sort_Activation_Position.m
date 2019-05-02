% Sort activation position
%
% By Jesús Pérez-Ortega, Jan 2019

function [sequences_sorted,position,probabilities] = Sort_Activation_Position(sequences)
    [trials,n] = size(sequences);
    
    % without "neuron 0"
    % get the probability of activation
    for i = 1:n
        p = sum(sequences==i)/trials;
        probabilities(i,:) = p;
    end
    
    % Set the activation position
    % C
    [~,position] = Sort_Raster(probabilities);
    
    % sort the sequence
    sequences_sorted = zeros(trials,n);
    for i = 1:n
        sequences_sorted(sequences==position(i))=i;
    end
    
    % sort preference
    probabilities = probabilities(position,:);
    
% % set activation position (other methods)
% % A
%     remaining = 1:n;
%     for i = 1:n
%         [~,id] = max(preferences(remaining,i));
%         position(i) = remaining(id);
%         remaining = setdiff(remaining,remaining(id));
%     end
% 
% %     B
%     for i = 1:n
%         [~,position(i)] = max(preferences(i,:));
%     end
%     [~,position] = sort(position);
end

% % with "neuron 0" probability
%     % get the probability of activation
%     for i = 0:n
%         p = sum(sequences==i)/trials;
%         probabilities(i+1,:) = p;
%     end
%     
%     % Set the activation position
%     [~,position] = Sort_Raster(probabilities(2:end,:));
%     position = [1 position+1];
%     
%     % sort the sequence
%     sequences_sorted = zeros(trials,n);
%     for i = 0:n
%         sequences_sorted(sequences==position(i+1)-1)=i;
%     end
%     
%     % sort preference
%     probabilities = probabilities(position,:);
%     position = position(2:end)-1;
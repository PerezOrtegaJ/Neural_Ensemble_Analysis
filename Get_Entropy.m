function entropy = Get_Entropy(frequencies)
% Entropy from a list of frequencies
%
% By Pérez-Ortega Jesús, Feb 2019

n = length(frequencies);
total = sum(frequencies);

if(~total)
    entropy = nan;
    return
end

p = frequencies/total;

entropy = 0;
for i = 1:n
    if(p(i))
        entropy = entropy + p(i)*log2(p(i));
    end
end
entropy = -entropy;

% Plot instantaneous frequency (inverse of ISI)
%
% inputs: data = vector with spikes (0: no spike, 1: spike)
%         sps = samples per second (sampling frequency)
%
% By Jesús E. Pérez-Ortega - may 2017
% modified jan-2018

function frequencies = Get_Instant_Freq(data,sps)
        
    N=length(data);
    frequencies=zeros(1,N);

    idx=find(data);

    % if there are spikes
    if (~isempty(idx))
        % If first data is not a spike
        if (idx(1)~=1)
            frequencies(1:idx(1))=sps/(idx(1)-1);
        end

        % All ISI inverse
        n=length(idx)-1;
        for j=1:n
            frequencies(idx(j):idx(j+1))=sps/(idx(j+1)-idx(j));
        end

        % If last data is not a spike
        if(idx(n+1)~=N)
            frequencies(idx(n+1):N)=sps/(N-idx(n+1));
        end
    end
end
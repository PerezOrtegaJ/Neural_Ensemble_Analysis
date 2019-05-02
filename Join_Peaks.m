%% Join Peaks
% Modified jan-2018
function Peaks = Join_Peaks(StatesIdx,PeaksIdx)
    
    NS=length(StatesIdx);
    NP=length(PeaksIdx);
    if NS~=NP
        for i=1:NS
            idx(i)=find(PeaksIdx==i,1,'first');
        end
    else
        idx=find(PeaksIdx);
    end
    
    F=length(idx);
    Peaks(1)=StatesIdx(1);
    j=2;
    for i=2:F
        if idx(i-1)~=idx(i)-1
            Peaks(j)=StatesIdx(i);
            j=j+1;
        end
    end
end
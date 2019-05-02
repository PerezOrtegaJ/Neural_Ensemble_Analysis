% Cluster Connectivity index 2
% Get cluster connectivity index of neuronal groups of peaks.
% Mean of the groups' connectivity index
% (This is an idea of Jesús E. Pérez-Ortega, José Bargas, et al.)
%
% [CCI] = CCidx2_JP(g,Xp,idx)
%
% Inputs
% g = number of groups
% Xp = binary data as matrix PxC (P = #peaks, C = #cells)
% idx = indexes of group to which each data point belongs
% 
% Outputs
% CCI = Connectivity index
%
% ..:: by Jesús E. Pérez-Ortega ::.. Mar-2012

function [CCI] = CCidx2_JP(g,Xp,idx)

P=size(Xp,1);
C_intra=zeros(g,1);   % connectivity inter-group
single=0;             % single neuronal vector
for i=1:g
    clust = find(idx==i);
    PM=Xp(clust,:); 
    idxPM=find(sum(PM,1));
    PM=PM(:,idxPM);
    if size(PM,1)==1    % if single not be taken into account
        C_intra(i,1)=0; % unlike with the first version: 1 instead of 0
        single=single+1;
    else
        C_intra(i,1)=CI_JP(PM);
    end
end
% disp(C_intra)
CCI=sum(C_intra)/g; % unlike with the first version: g instead of (g-single)




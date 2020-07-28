function ids = Compare_Ensembles(structureA,structureB,simTh)
% Compare ensembles by its neural identity using a threshold of imilarity
%
%       ids = Compare_Ensembles(structureA,structureB,simTh)
%
% By Jesus Perez-Ortega, May 2020

% Compute similarity between ensemble neurons
simNeurons = 1-pdist2(double(structureA>0),double(structureB>0),'Jaccard')';
[maxSim,maxSimID] = max(simNeurons,[],1);

% Identify ensembles from A above similarity threshold
sameA = find(maxSim>=simTh);

% Identify similar ensembles from B
sameB = maxSimID(sameA);
nSameB = length(sameB);
nSameUniqueB = length(unique(sameB));

% Check for more than one similar
if nSameB>nSameUniqueB
    disp('Some ensembles from B are similar to more than one ensemble from A.')
    idRemove = [];
    for i = 1:nSameUniqueB
        id = find(sameB==sameB(i));
        if length(id)>1
            % Detect more similar
            [~,maxID] = max(maxSim(id));
            
            % Keep more similar and remove the others
            idKeep = id(maxID);
            idRemove = [idRemove setdiff(id,idKeep)];
        end
    end
    sameA(idRemove) = [];
    sameB(idRemove) = [];
    disp([num2str(length(idRemove)) ' ensembles were removed.'])
end

% Get number of ensembles
nA = size(structureA,1);
nB = size(structureB,1);

% Add values to ids structure
ids.SameA = sameA;
ids.SameB = sameB;
ids.DiffA = setdiff(1:nA,sameA);
ids.DiffB = setdiff(1:nB,sameB);
ids.nA = nA;
ids.nB = nB;

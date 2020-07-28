function [relevant,cleanedRaster,relevantFraction,spikesFractionRemoved,similarity,treeID,vectorID] =...
    Get_Relevant_Coactivations(raster,net,distanceTh)
% Get the relevant coactivations based on funtional connections
% (trick to reduce the noisy vectors to better extract neuronal ensembles)
%
%       [relevant,cleanedRaster,relevantFraction,spikesFractionRemoved,similarity,treeID,vectorID] =
%    Get_Relevant_Coactivations(raster,net,distanceTh)
%
% By Jesus Perez-Ortega, Dec 2019
% Modified May 2020
% Modified Jun 2020

% Remove noisy spikes based on functional connections
disp('   Removing noisy spikes...')
[cleanedRaster,spikesFractionRemoved] = Remove_Noisy_Spikes(raster,net);
%nonNoisyRaster = raster;

% Detect coactivations above 2 active neurons
disp('   Finding coactivation peaks...')
vectorID = Find_Peaks_Or_Valleys(sum(cleanedRaster),2,false);

if nnz(vectorID)>1
    neuronalVectors = Get_Peak_Vectors(cleanedRaster,vectorID,'binary');
    nCoactive = nnz(sum(raster)>2);
    nPeaks = max(vectorID);
    disp(['   ' num2str(nPeaks) '/' num2str(nCoactive) '(' num2str(nPeaks/nCoactive*100) '%) >2 coactive cells'])

    % Get the hierarchichal clustering
    disp(['   Get relevant coactivity vectors (>' num2str(1-distanceTh) ' jaccard similarity in dendrogram tree)...'])
    similarity = Get_Peaks_Similarity(neuronalVectors,'jaccard');
    tree = linkage(squareform(1-similarity,'tovector'),'single');

    % Get id from dendrogram
    figure; [~,~,treeID] = dendrogram(tree,0); close

    % Find the limit to consider relevant given a threshold
    limit = find(tree(:,3)>distanceTh,1,'first')-1;
    if isempty(limit)
        relevant = vectorID>0;
    else
        relevant = zeros(size(vectorID));
        for i = 1:limit
            relevant(vectorID==treeID(i)) = 1;
        end
    end

    nRelevant = nnz(relevant);
    relevantFraction = nRelevant/nCoactive;
    disp(['   ' num2str(nRelevant) '/' num2str(nCoactive) '(' num2str(relevantFraction*100) '%) relevant'])
else
    relevant = [];
    treeID = [];
    relevantFraction = [];
    similarity = [];
    warning('   There are less than 2 relevant coactive vectors!')
end
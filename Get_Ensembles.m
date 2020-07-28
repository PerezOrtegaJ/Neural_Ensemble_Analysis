function analysis = Get_Ensembles(raster)
% Get ensembles from raster
%
%       analysis = Get_Ensembles(raster)
%
%       default: options = [];
%
% By Jesus Perez-Ortega, May 2020
% Modified June, 2020

% bin = options.Network.Bin;
% iterations = options.Network.Iterations;
% alpha = options.Network.Alpha;
% networkMethod = options.Network.NetworkMethod;
% shuffleMethod = options.Network.ShuffleMethod;
% singleTh = options.Network.SingleThreshold;

% Get significant network
rng(0)
network = Get_Significant_Network_From_Raster(raster);
%,bin,iterations,alpha,networkMethod,shuffleMethod,singleTh); 

% Get relevant coactivations
% frames with more than 2 coactive neurons and jaccard similarity > 0.666
[relevant,cleanedRaster,relevantFraction,spikesFractionRemoved,similarityBefore,treeIDpre,vectorIDBefore] = ...
    Get_Relevant_Coactivations(raster,network,1/3);

% Get relevant vectors
vectorID = Find_Peaks_Or_Valleys(relevant,0.5,false);
if isempty(vectorID)
    warning('    There are no ensembles.')
    analysis = [];
    return
end

rasterVectors = Get_Peak_Vectors(raster,vectorID,'binary');

% Get similarit~y
similarity = Get_Peaks_Similarity(rasterVectors,'jaccard');

% Get recommended number of ensembles
tree = linkage(squareform(1-similarity,'tovector'),'ward');
figure; [~,~,treeID] = dendrogram(tree,0); close
[groups,contrastID] = Cluster_Test(tree,similarity,'contrast','hierarchical',2:10);

% Get clusters
sequence = cluster(tree,'maxclust',groups);
sequence = Get_Peaks_Sequence_Sorted(sequence);

% Get ensemble network
[ensembleNetworks,ensembleRasters,ensembleRaws] = Get_Ensemble_Networks(raster,vectorID,sequence);

% Get ensambles structure
[structure,networkMixed] = Get_Ensemble_Identity(ensembleNetworks);

% Analyze structure in order to identify same ensembles
%
similarityEnsembles = 1-squareform(pdist(structure>0,'Jaccard'))-eye(groups);
simTh = 1/2; % 2/3 strict, 1/2 regular, 1/3 less strict
nSimilar = nnz(sum(similarityEnsembles>simTh));
if nSimilar
    disp(['There are ' num2str(nSimilar) ' ensembles that are similar, so they will be joined!'])
    
    % Identify the similar ensembles
    j = 1;
    for i = 1:groups-1
        id = find(similarityEnsembles(i,i:end)>simTh)+i-1;
        if ~isempty(id)
            similar(j,1:length(id)+1) = [i id];
            j = j+1;
        end
    end
    
    % Join ensembles
    for i = size(similar,1):-1:1
        sequence(sequence==similar(i,2)) = similar(i,1);
    end
    j = 1;
    for i = unique(sequence')
        sequence(sequence==i) = j;
        j = j+1;
    end
    sequence = Get_Peaks_Sequence_Sorted(sequence);
    
    % Get ensemble network
    [ensembleNetworks,ensembleRasters,ensembleRaws] = Get_Ensemble_Networks(raster,vectorID,sequence);

    % Get ensambles structure
    [structure,networkMixed] = Get_Ensemble_Identity(ensembleNetworks);
end
%}

% Get fraction of vectors between days
[within,count] = Similarity_Within_Rasters(ensembleRasters);

% Number of ensemble activation and duration
[widths,peaksCount] = Get_Ensembles_Length(vectorID,sequence);

% Add to analysis structure
analysis.Network = network;

analysis.Relevant.RelevantFrames = relevant;
analysis.Relevant.CleanRaster = cleanedRaster;
analysis.Relevant.RelevantFraction = relevantFraction;
analysis.Relevant.SpikesFractionRemoved = spikesFractionRemoved;
analysis.Relevant.RasterVectors = rasterVectors;
analysis.Relevant.VectorID = vectorID;
analysis.Relevant.SimilarityBefore = similarityBefore;
analysis.Relevant.TreeID = treeIDpre;
analysis.Relevant.VectorIDBefore = vectorIDBefore;

analysis.Clustering.Similarity = similarity;
analysis.Clustering.Tree = tree;
analysis.Clustering.RecommendedClusters = groups;
analysis.Clustering.ContrastIndex = contrastID;
analysis.Clustering.TreeID = treeID;

analysis.Ensembles.ActivationSequence = sequence;
analysis.Ensembles.Networks = ensembleNetworks;
analysis.Ensembles.Rasters = ensembleRasters;
analysis.Ensembles.Raws = ensembleRaws;
analysis.Ensembles.Similarity = within;
analysis.Ensembles.VectorCount = count;
analysis.Ensembles.Structure = structure;
analysis.Ensembles.NetworkMixed = networkMixed;
analysis.Ensembles.Durations = widths;
analysis.Ensembles.PeaksCount = peaksCount;
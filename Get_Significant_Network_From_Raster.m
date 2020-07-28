function [A_significant,A_raw,th,As] = Get_Significant_Network_From_Raster(raster,bin,...
    iterations,alpha,networkMethod,shuffleMethod,singleTh)
% Get significant network from raster
%
%       [A_significant,A_raw,th,As] = Get_Significant_Network_From_Raster(raster,bin,...
%           iterations,alpha,networkMethod,shuffleMethod,singleTh)
%
%       default: bin = 1; iterations = 1000; alpha = 0.05; networkMethod = 'coactivity'
%                shuffleMethod = 'time_shift'; singleTh = true;
%
% Jesus Perez-Ortega, nov 2018
% Modified May 2020

tic
switch nargin
    case 6
        singleTh = true;
    case 5
        shuffleMethod = 'time_shift';
        singleTh = true;
    case 4
        networkMethod = 'coactivity';
        shuffleMethod = 'time_shift';
        singleTh = true;
    case 3
        alpha = 0.05;
        networkMethod = 'coactivity';
        shuffleMethod = 'time_shift';
        singleTh = true;
    case 2
        iterations = 1000;
        alpha = 0.05;
        networkMethod = 'coactivity';
        shuffleMethod = 'time_shift';
        singleTh = true;
    case 1
        bin = 1;
        iterations = 1000;
        alpha = 0.05;
        networkMethod = 'coactivity';
        shuffleMethod = 'time_shift';
        singleTh = true;
end

% Reduce raster in bin
raster_bin = Reshape_Raster(raster,bin);

% Get original adjacency network
A_raw = Get_Adjacency_From_Raster(raster_bin,networkMethod);

% Random versions
nNeurons = length(A_raw);
As = zeros(iterations,(nNeurons^2-nNeurons)/2);
disp('Shuffling data...')
for i = 1:iterations
    shuffled = shuffle(raster,shuffleMethod);
    shuffled_bin = Reshape_Raster(shuffled,bin);
    As(i,:) = squareform(Get_Adjacency_From_Raster(shuffled_bin,networkMethod),...
        'tovector');
    
    % Show the state of computation each 100 frames
    if ~mod(i,100)
        t = toc; 
        fprintf('   %d/%d iterations, %.1f s\n',i,iterations,t)
    end
end
        
if singleTh
    n_edges = size(As,2);
    th = zeros(1,n_edges);
    for i = 1:n_edges
        th_i = Find_Threshold_In_Cumulative_Distribution(As(:,i),alpha);
        th(i) = th_i;
    end
    th = squareform(th);
else
    th = Find_Threshold_In_Cumulative_Distribution(As(:),alpha);
end

% Get significant adjacency
A_significant = A_raw>th;
t = toc; 
fprintf('Done in %.1f s\n',t)

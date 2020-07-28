function [A_significant,A_raw,th] = Get_Significant_Network_From_Raster_And_Correlation(raster,...
    correlation,bin,iterations,alpha,network_method,shuffle_method,single_th)
% Get significant network from raster an coactivity
%
%       [A_significant,A_raw,th] = Get_Significant_Network_From_Raster_And_Correlation(raster,...
%    correlation,bin,iterations,alpha,network_method,shuffle_method,single_th)
%
%       default: bin = 1; iteration = 1000; alpha = 0.05; network_method = 'coactivity';
%                shuffle_method = 'time_shift'; single_th = true;
%
%
% Jesús Pérez-Ortega, nov 2018
% Modified August 2019

if(nargin == 7)
    single_th = true;
elseif(nargin == 6)
    single_th = true;
    network_method = 'coactivity';
elseif(nargin == 5)
    single_th = true;
    shuffle_method = 'time_shift';
elseif(nargin == 4)
    single_th = true;
    shuffle_method = 'time_shift';
    network_method = 'coactivity';
    alpha = 0.05;
elseif(nargin == 3)
    single_th = true;
    shuffle_method = 'time_shift';
    network_method = 'coactivity';
    alpha = 0.05;
    iterations = 1000;
elseif(nargin == 2)
    single_th = true;
    shuffle_method = 'time_shift';
    network_method = 'coactivity';
    alpha = 0.05;
    iterations = 1000;
    bin=1;
end

% Reduce raster in bin
raster_bin = Reshape_Raster(raster,bin);
neurons = size(raster_bin,1);

% Get original adjacency network
A_raw = Get_Adjacency_From_Raster(raster_bin,network_method);

% Get adjacency with correlation weights
co(1,:) = correlation;
ws = co'*co;

A_raw_co = A_raw.*ws;

% Random versions
As_shuffled = [];
tic
disp('Shuffling data...')
for i = 1:iterations
    shuffled = shuffle(raster,shuffle_method);
    shuffled_bin = Reshape_Raster(shuffled,bin);

    % Get adjacency
    A_shuffled = Get_Adjacency_From_Raster(shuffled_bin,network_method);

    % Get correlation with the coactivity
    %ws = reshape(weights(randperm(neurons*neurons)),neurons,neurons);        
    co = co(randperm(neurons));
    ws = co'*co;

    A_shuffled_co = A_shuffled.*ws;
    As_shuffled(i,:) = squareform(A_shuffled_co,'tovector');
    % Show the state of computation each 100 iteration
    if ~mod(i,100)
        t = toc; 
        fprintf('   %d/%d iterations, %.1f s\n',i,iterations,t)
    end
end

if(single_th)
    n_edges = size(As_shuffled,2);
    th = zeros(1,n_edges);
    for i = 1:n_edges
        th_i = Find_Threshold_In_Cumulative_Distribution(As_shuffled(:,i),alpha);
        th(i) = th_i;
        % Show the state of computation each 100 iteration
        if ~mod(i,10000)
            t = toc; 
            fprintf('%d/%d, %.1f s\n',i,n_edges,t)
        end
    end
    th = squareform(th);
else
    th = Find_Threshold_In_Cumulative_Distribution(As_shuffled(:),alpha);
end

% Get significant adjacency
A_significant = A_raw_co>th;

t=toc; disp(['   Done (' num2str(t) ' seconds)'])
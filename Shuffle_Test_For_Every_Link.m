% Weight threshold
% 
% Montecarlo for determining weight threshold in weighted matrix.
% 
% Threshold is determined when the edges reach the 1-alpha percentage in
% its randomized versions (N times).
%
% Adjacency matrix is determined by coactivity, weight of connection means
% the times which are two nodes coactive.
%
% w_ths = Shuffle_Test_For_Every_Link(raster,shuffle_method,connectivity_method,iterations,alpha)
% 
% Jesus E. Perez-Ortega - Sep 2018
% modified june 2018
% modified nov 2018

function w_ths = Shuffle_Test_For_Every_Link(raster,shuffle_method,connectivity_method,iterations,alpha)

    % Data size
    n = size(raster,1);
    adjacency_shuffle=zeros(iterations,n,n);
    
    for i=1:iterations
        % Shuffled version
        raster_shuffled = shuffle(raster,shuffle_method);
        
        % Adjacent from shuffled version
        adjacency_shuffle(i,:,:)=Get_Adjacency_From_Raster(raster_shuffled,connectivity_method);
    end
    
    % Cumulative distribution of individual link
    w_ths = zeros(n);
    for j=1:n-1
        for k=j+1:n
            try
                y=hist(adjacency_shuffle(:,j,k),0:max(adjacency_shuffle(:,j,k)));
                cum=cumsum(y)/max(cumsum(y));
                th=find(cum>(1-alpha),1,'first')-1;
                w_ths(j,k)=th;
                w_ths(k,j)=w_ths(j,k);
            catch
                disp(th)
            end
        end
    end 
end
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
% W_Th = WeightTh(Data, N, alpha)
% 
% ..:: by Jes?s E. P?rez-Ortega ::.. Jun-2013 
% modified june 2018

function w_threshold = Shuffle_Test_For_Weighted_Matrix(raster,shuffle_method,connectivity_method,iterations,alpha)

    % Data size
    samples=size(raster,2);

    for i=1:iterations
        % Shuffled version
        raster_shuffled = shuffle(raster,shuffle_method);      % Get raster shuffled
        
        % Adjacent from shuffled version
        adjacency_shuffle=Get_Adjacency_From_Raster(raster_shuffled,connectivity_method);
        
        % Number of edges at each threshold
        edges_th_shuffled=zeros(1,100);
        if(strcmp(connectivity_method,'jaccard'))
            interval=0:0.001:1;
        else
            interval=0:samples;
        end
        j=1;
        for th=interval
            edges_th_shuffled(j)=sum(sum(adjacency_shuffle>th));
            if(~edges_th_shuffled(j))
                break;
            end
            j=j+1;
        end

        % Coactivation probability
        p(i,1:length(edges_th_shuffled)) = cumsum(edges_th_shuffled)/max(cumsum(edges_th_shuffled));           
    end
    p(p==0)=1;
    p_mean=mean(p);
    interval=interval(1:length(p_mean));
    % Weight threshold
    idx=find(p_mean>(1-alpha),1,'first');
    w_threshold=interval(idx);
    
    % Plot distribution shuffled
    Set_Figure('Shuffled weigthed matrix test',[0 0 600 300]);
    %plot(interval/samples,p_mean,'o-b');
    plot(interval,p_mean,'o-b');
    title({['Cumulative distribution of raster shuffled (' num2str(iterations) ' iterations; method '...
        strrep(shuffle_method,'_','-') ')'];['th = ' num2str(w_threshold) ' at alpha=' num2str(alpha)]})
    ylabel('P(x)')
    xlabel('x')
    ylim([0 1.05])
    if(~isnan(w_threshold) && w_threshold>0)
        xlim([0 (w_threshold*2)])
    end
    %w_threshold=w_threshold/100;
end
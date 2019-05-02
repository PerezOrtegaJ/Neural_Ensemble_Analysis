% Test for significant number of coactive neurons
%
% P?rez Ortega Jes?s E. - March 2018
% Modified April 2018

function Th = Shuffle_Test(raster,smooth_window,n,shuffle_method,alpha,...
    integer_interval,remove_oscillations,z_score,only_mean,zscore_window,plot_shuffled_figures)

    if(nargin==7)
        plot_shuffled_figures=false;
    elseif(nargin==6)
        plot_shuffled_figures=false;
        remove_oscillations=false;
    elseif(nargin==5)
        plot_shuffled_figures=false;
        remove_oscillations=false;
        integer_interval=true;
    elseif(nargin==4)
        plot_shuffled_figures=false;
        remove_oscillations=false;
        integer_interval=true;
        alpha=0.05;
    elseif(nargin==3)
        plot_shuffled_figures=false;
        remove_oscillations=false;
        integer_interval=true;
        alpha=0.05;
        shuffle_method='time_shift';
    end
    
    [c,f]=size(raster);
    smooth_coactivity = Get_And_Filter_Coactivity(raster,smooth_window);
    
    % Remove Oscillations
    if(remove_oscillations)
        smooth_coactivity = Remove_Oscillations(smooth_coactivity);
    end
    
    % Z-score
    if(z_score)
        smooth_coactivity=Z_Score_Coactivity(smooth_coactivity,zscore_window,only_mean);
    end

    if(integer_interval)
        interval=1:c;
        PS=zeros(n,c);
    else
        interval=0:.1:max(smooth_coactivity);
        PS=zeros(n,length(interval));
    end
    
    % Plot only if necessary
    if(plot_shuffled_figures)
        Set_Figure('Raster | real VS shuffled',[0 0 1000 800]);
        subplot(5,1,1)
        imagesc(raster)
        title('Observed')
        colormap([1 1 1; 0 0 0])
        Set_Figure('Coactivity | real VS shuffled',[0 0 1000 800]);
        subplot(5,1,1)
        plot(smooth_coactivity)
        title('Observed')
        y_limits=get(gca,'ylim');    
    end
    
    % SHUFFLED data
    for i=1:n
        R_shuffled = shuffle(raster,shuffle_method);      % Get raster shuffled
        smooth_co = Get_And_Filter_Coactivity(R_shuffled,smooth_window);  % Get coactivity
        % Remove Oscillations
        if(remove_oscillations)
            smooth_co = Remove_Oscillations(smooth_co);
        end
        
        % Z-score
        if(z_score)
            smooth_co=Z_Score_Coactivity(smooth_co,0,only_mean);
        end
        
        HS = histc(smooth_co,interval);                 % Histogram of coactive cells
        %PS(i,:) = cumsum(HS)/f;                         % Synchrony probability
        PS(i,:) = cumsum(HS)/max(cumsum(HS));           % Synchrony probability
        
        % Plot only if necessary
        if(plot_shuffled_figures && i<5)
            Hold_Figure('Raster | real VS shuffled');
            subplot(5,1,i+1)
            imagesc(R_shuffled)
            title(['Shuffled ' num2str(i)])
            Hold_Figure('Coactivity | real VS shuffled')
            subplot(5,1,i+1)
            plot(smooth_co)
            title(['Shuffled ' num2str(i)])
            ylim(y_limits)
        end
    end
    PSmean=mean(PS);                                    % Mean of Probability

    % Set threshold from Probability distribution < alpha
    th_idx=find(PSmean>=(1-alpha),1,'first');
    Th=interval(th_idx);
    
    % Plot distribution shuffled
    Set_Figure('Shuffled test',[0 0 600 300]);
    plot(interval,PSmean,'o-b'); hold on
    title({['Cumulative distribution of raster shuffled (' num2str(n) ' iterations; method '...
        strrep(shuffle_method,'_','-') ')'];['th = ' num2str(Th) ' at alpha=' num2str(alpha)]})
    ylabel('P(x)')
    xlabel('x')
    if(~isnan(Th))
        xlim([0 Th*3])
    end
end
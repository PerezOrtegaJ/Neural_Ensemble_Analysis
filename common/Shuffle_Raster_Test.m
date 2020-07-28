function [threshold,cdf] = Shuffle_Raster_Test(raster,shuffle_method,iterations,alpha,plot_figure)
% Test for significant number of coactive neurons
%
%       function [threshold,cpd] = Shuffle_Raster_Test(raster,shuffle_method,iterations,alpha,
%                                       plot_figure)
%
%       default: shuffled_method = 'time_shift'; iterations = 1000; alpha = 0.05;
%                plot_figure = false 
%
% Perez-Ortega Jesus - June 2019

switch nargin
    case 1
        shuffle_method='time_shift';
        iterations = 1000;
        alpha=0.05;
        plot_figure = false;
    case 2
        iterations = 1000;
        alpha=0.05;
        plot_figure = false;
    case 3
        alpha=0.05;
        plot_figure = false;
    case 4
        plot_figure = false;
end

% Get raster
coactivity = sum(raster);

% Initialize variables
samples = size(raster,2);
coactivity_shuffled = zeros(iterations,samples);

% Plot only if necessary
if plot_figure
    Set_Figure('Raster | real VS shuffled',[0 0 1000 800]);
    subplot(5,1,1)
    imagesc(raster)
    title('Observed')
    colormap([1 1 1; 0 0 0])
    Set_Figure('Coactivity | real VS shuffled',[0 0 1000 800]);
    subplot(5,1,1)
    plot(coactivity)
    title('Observed')
    y_limits=get(gca,'ylim');    
end

% SHUFFLED data
for i = 1:iterations
    % Get raster shuffled
    raster_shuffled = shuffle(raster,shuffle_method); 
    
    % Get coactivity
    coactivity_shuffled(i,:) = sum(raster_shuffled);
    
    % Plot only if necessary
    if(plot_figure && i<5)
        Hold_Figure('Raster | real VS shuffled');
        subplot(5,1,i+1)
        imagesc(raster_shuffled)
        title(['Shuffled ' num2str(i)])
        Hold_Figure('Coactivity | real VS shuffled')
        subplot(5,1,i+1)
        plot(coactivity_shuffled(i,:))
        title(['Shuffled ' num2str(i)])
        ylim(y_limits)
    end
end

% cumulative distribution function of coactive cells
interval = 0:max(coactivity_shuffled(:));
cdf = histcounts(coactivity_shuffled(:),interval,'Normalization','cdf');

% Set threshold from Probability distribution < alpha
threshold = find(cdf>(1-alpha),1,'first');

% Plot distribution shuffled
if plot_figure
    Set_Figure('Shuffled test',[0 0 600 300]);
    plot(interval(1:end-1),cdf,'o-b'); hold on
    title({['Cumulative distribution of raster shuffled (' num2str(iterations) ' iterations; method '...
        strrep(shuffle_method,'_','-') ')'];['th = ' num2str(threshold) ' at alpha=' num2str(alpha)]})
    ylabel('P(x)')
    xlabel('x')
    if(~isnan(threshold))
        xlim([0 threshold*3])
    end
end
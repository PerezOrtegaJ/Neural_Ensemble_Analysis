% Plot Raster
%
% Plot raster in figure, plot coactive cells and plot cells activity.
%
% [Co Ac] = PlotR_JP(X, figure, titlePlot, color)
%
% Inputs
% X = binary data as matrix FxC (F = #frames, C = #cells)
% numFig = number of the figure to plot.
% titlePlot = title of the plot as string.
% color = color of the plot as vector 1x3 [R G B].
% 
% Outputs
% Figure with plots.
% Co = Coactive cells along the frames.
% Ac = Accumulated activity along the cells.
% 
% ..:: by Jesús E. Pérez-Ortega ::.. Mar-2012

function [Co Ac] = PlotR_JP(X, numFig, titlePlot, color)

[F C]=size(X);
figure(numFig); clf

% Plot Raster
subplot(5,5,[1:4 6:9 11:14 16:19])
title(titlePlot)
axis([1 F 1 C])
hold on
for i=1:C
    idx=find(X(:,i));
    plot(idx,X(idx,i)*i,'.','color',color)
end
hold off
set(gca,'XTicklabel','')
set(gca,'XTick',0)
box

% Plot Coactive cells
subplot(5,5,[21:24])
Co=sum(X,2);
plot(Co,'color',color)
xlim([1 F])

% Plot Accumulated activity
subplot(5,5,[5;10;15;20])
Ac=sum(X,1);
plot(Ac,'*-','color',color)
set(gca,'XTicklabel','')
set(gca,'XTick',0)
xlim([1 C])
view([90 -90])
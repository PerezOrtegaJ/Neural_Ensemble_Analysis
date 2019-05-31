% Plot degree distribution
%
% Jesús Pérez-Ortega
% modified nov 2018

function [slope,R2,intercept] = Plot_Degree_Distribution(adjacency,name,save)
    
    if(nargin==2)
        save=false;
    end

    cells=length(adjacency);
    links=sum(adjacency,1);

    if ~links
        warning('There are no links.')
        return;
    end
    
    % Get links histogram (only neurons with at least one link)
    links_1=links(links>0);
    N=length(links_1);
    nbins = round(log2(N)+1);   % Sturges rule
    %nbins = 2*iqr(links_1)*N^(-1/3);    % Freedman-Diaconis rule for heavy tailed
    
    [y,x]=hist(links_1,nbins);
    y=y/sum(y);
    
    % Plot power law fit
    try
        [slope, intercept, R2] = Fit_Power_Law(x',y');
    catch
        slope=NaN;
        intercept=NaN;
        R2=NaN;
        return
    end
    xfit=min(x):(max(x)-min(x))/100:max(x);
    yfit=intercept*xfit.^(slope);
    
    % Plot Links
    Set_Figure(['Links - ' name],[0 0 600 200]);
    Set_Axes(['Links ' name],[0 0 1 1])
    plot(find(links>0),links_1,'ob'); hold on
    plot(find(links==0),links(links==0),'or')
    set(gca,'xlim',[0 cells],'ylim',[0 max(links)+1])
    title(name); xlabel('# neuron'); ylabel('Count of links')
    
    % Save
    if(save)
        Save_Figure([name ' - Links' ]);
    end
    
    % Plot linear links histogram
    Set_Figure(['Distribution - ' name],[0 0 600 200]);
    Set_Axes(['Links ' name],[0 0 0.5 1])
    plot(x,y,'ob','markersize',10); hold on
    plot(xfit,yfit,'k')
    xlabel('k'); ylabel('P(k)'); title(['Degree distribution - ' name])

    % Write the coefficients
    text(max(x)/2,max(y)*0.8,['\lambda=' num2str(-slope,'%0.1f')],'FontSize',14,'FontWeight','bold')
    text(max(x)/2,max(y)*0.6,['R^2=' num2str(R2,'%0.3f')],'FontSize',14,'FontWeight','bold')
    
    % Plot loglog links histogram
    Set_Axes(['HistLinksPL ' name],[0.5 0 0.5 1])
    loglog(x,y,'ob','markersize',10); hold on
    loglog(xfit,yfit,'k')
    xlabel('k'); ylabel('P(k)'); title(['Degree distribution - ' name])
    
    % Save
    if(save)
        %Save_Figure([name ' - Distribution']);
        Save_Figure([name ' - Distribution'],'eps');
    end
    
end
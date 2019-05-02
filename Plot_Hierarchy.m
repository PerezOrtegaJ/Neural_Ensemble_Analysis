% Plot clustering coefficient in function of degree C(k) vs k
%
% Jesús Pérez-Ortega 
% Modified Jan 2019

function [slope,R2,intercept,links,clocal] = Plot_Hierarchy(adjacency,name,save)
    switch(nargin)
        case 1
            name = '';
            save = false;
        case 2
            save= false;
    end

    % Number of cells
    N=length(adjacency);
    
    if ~N
        links=0;
        clocal=0;
        return;
    end

    links=sum(adjacency)';
    clocal=clustering_coef_bu(adjacency);
    l=links;
    c=clocal;
        
    % delete zeros clustering coefficients
    x=links(clocal>0);
    y=clocal(clocal>0);
    
    Set_Figure([name ' - Hierarchy'],[0 0 600 200]);
    
    [slope, intercept, R2] = Fit_Power_Law(x,y);
    xfit=min(x):(max(x)-min(x))/100:max(x);
    yfit=intercept*xfit.^slope;

    % linear plot
    Set_Axes(['Axes - C(k) lineal' name],[0 0 0.5 1]); hold on
    plot(xfit,yfit,'k','linewidth',2,'markersize',10); hold on
    plot(l,c,'or','linewidth',2,'markersize',10)
    xlabel('k'); ylabel('C(k)')
    title('Local Clustering Coeficient C(k)')

    % Write the coefficients
    text(max(x)/2,max(y)*0.8,['\alpha=' num2str(-slope,'%0.1f')],'FontSize',14,'FontWeight','bold')
    text(max(x)/2,max(y)*0.6,['R^2=' num2str(R2,'%0.3f')],'FontSize',14,'FontWeight','bold')
    
    % loglog plot
    Set_Axes(['Axes - C(k) loglog' name],[0.5 0 0.5 1])
    loglog(xfit,yfit,'k','linewidth',2,'markersize',10); hold on
    loglog(l,c,'or','linewidth',2,'markersize',10)
    xlabel('k'), ylabel('C(k)')
    title('Local Clustering Coeficient C(k)')
    
    if(save)
        Save_Figure([name ' - Hierarchy'])
    end
end
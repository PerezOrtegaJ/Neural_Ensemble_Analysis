% Plot rich-club ordering
%
% By Jesús Pérez-Ortega, Jan 2019

%function [R_index,R_index_rnd] = Plot_Rich_Club(adjacency,name,save)
function [R_index] = Plot_Rich_Club(adjacency,name,save)

    switch(nargin)
        case 1
            name = '';
            save = false;
        case 2
            save = false;
    end
    
    % Get basic properties
    N = length(adjacency);
    links = sum(adjacency);
    K = sum(links)/2;
    K_mean = 2*K/N;
    level = round(sqrt(N*K_mean));
    
    % Get rich-club index
    Rclub = rich_club_bu(adjacency,level);
%     Rclub_rnd = rich_club_bu(makerandCIJ_und(N,K),level);
    
    % 1,000 iterations
    for i = 1:1000
        Rclub_rnds(i,:) = rich_club_bu(makerandCIJ_und(N,K),level);
    end
    Rclub_rnd_avg = nanmean(Rclub_rnds);
    
    % Get rich-club ordering
    R_index = Rclub./Rclub_rnd_avg;
    %R_index_rnd = Rclub_rnd./Rclub_rnd_avg;

    Set_Figure([name ' - Rich club'],[0 0 300 200]);
    semilogx(R_index,'o','color',[0 0.5 0],'markersize',10); hold on
    %semilogx(R_index_rnd,'or','markersize',10)
    plot([1 length(R_index)],[1 1],'--k')
    %legend({'Real','ER'})
    xlabel('k'), ylabel('\rho_{ran}(k)')
    title([ name ' - Rich-club ordering'])
    
    ylims = get(gca,'ylim');
    ylims(1) = 0;
    ylim(ylims)
    
    if(save)
        Save_Figure([ name ' - Rich-club ordering'])
    end
end
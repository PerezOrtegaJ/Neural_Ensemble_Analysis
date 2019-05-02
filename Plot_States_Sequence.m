% Plot sequence
%
% P?rez-Ortega Jes?s - March 2018
% modified Aug-2018
function count_states = Plot_States_Sequence(sequence,noise_group,name,group_colors)
    n=max(sequence);
    default_colors= Read_Colors(n);
    switch(nargin)
        case 1
            noise_group=0;
            name='untitled';
            group_colors=default_colors;
        case 2
            name='untitled';
            group_colors=default_colors;
        case 3
            group_colors=default_colors;
    end 
    groups=max(sequence);
    
    Set_Figure(['States Sequence - ' name],[0 0 1220 200]);
    Set_Axes('States sequence',[-.05 0 .85 1]); hold on
    for i=noise_group
        sequence=sequence(sequence~=i);
    end
    for i=1:max(sequence)
        idx=find(sequence==i);
        ns=length(idx);
        count_states(i)=ns;
        plot(idx,repmat(i,ns,1),'o','color',group_colors(i,:),'markersize',10,...
            'linewidth',2)
    end
    plot(sequence,'-k')
    ylim([0 groups+1]); ylabel('State')
    l=length(sequence);
    xlim([0 l+1]); xlabel('# peak')
    title(['States sequence - ' strrep(name,'_','-')])
    
    Set_Axes('States count',[0.71 0.1 .15 .85]); hold on
    for i=1:max(sequence)
        bar(i,count_states(i),'FaceColor',group_colors(i,:)); hold on
    end
    set(gca,'xtick',[]); ylabel('count');
    view(90,-90)
    
    n=length(sequence)-1;
    transitions=sum(diff(sequence)~=0)/n;
    same=1-transitions;
    Set_Axes('transitions',[0.86 0 .14 1]); hold on
    bar([1 2],[same transitions]); hold on
    set(gca,'xtick',1:2,'xticklabel',{'same','between'});
    xlim([.5 2.5]); ylim([0 1])
    title('transitions'); ylabel('fraction');
end
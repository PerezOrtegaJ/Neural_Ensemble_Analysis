% Plot Peak states
%
% Pérez-Ortega Jesús - March 2018

function seqs = Plot_States_By_Width(sequence,width,name,save,group_colors)
    n=max(sequence);
    if (nargin==4)
        group_colors = Read_Colors(n);
    elseif(nargin==3)
        save=false;
        group_colors = Read_Colors(n);
    end

    states=max(sequence);
    n_seq=length(sequence);
    n_div=floor(n_seq/width);
    
    sub_fig=1;
    for i=1:n_div
        if(~mod(i-1,20))
            Set_Figure(['Sequences by width - ' name ' (' num2str(ceil(i/20)) ')' ],[0 0 1400 800]);
            sub_fig=1;
        end
        subplot(4,5,sub_fig)
        if(i*width>n_seq)
            seq_i=sequence(((i-1)*width+1):end);
            seqs(i,1:length(seq_i))=seq_i;
        else
            seq_i=sequence(((i-1)*width+1):i*width);
            seqs(i,:)=seq_i;
        end
        
        plot(seq_i,'-k');hold on
        for j=1:states
            idx=find(seq_i==j);
            ns=length(idx);
            plot(idx,repmat(j,ns,1),'o','color',group_colors(j,:),'markersize',10,...
                'linewidth',2)
        end
        ylim([1 states])
        title(['Sequence ' num2str(i)])
        
        sub_fig=sub_fig+1;
    end
    
    if(save)
        n_win=ceil(n_div/20);
        for i=1:n_win
            Hold_Figure(['Sequences by width - ' name ' (' num2str(i) ')']);
            Save_Figure(['Sequences by width - ' name ' (' num2str(i) ')']);
        end
    end
end

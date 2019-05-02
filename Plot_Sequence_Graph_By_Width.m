% Plot sequence graph by width
%
% Pérez-Ortega Jesús - April 2018

function adjacency_vectors = Plot_Sequence_Graph_By_Width(sequence,width,name,save,group_colors)
    n=max(sequence);
    if (nargin==4)
        group_colors = Read_Colors(n);
    elseif(nargin==3)
        save=false;
        group_colors = Read_Colors(n);
    end

    n_seq=length(sequence);
    n_div=floor(n_seq/width);
    n_nodes=max(sequence);
    
    sub_fig=1;
    for i=1:n_div
        if(~mod(i-1,20))
            Set_Figure(['Sequence graph - ' name ' (' num2str(ceil(i/20)) ')' ],[0 0 1400 800]);
            sub_fig=1;
        end
        subplot(4,5,sub_fig)
        if(i*width>n_seq)
            seq_i=sequence(((i-1)*width+1):end);
        else
            seq_i=sequence(((i-1)*width+1):i*width);
        end
        
        adjacency = Get_Adjacency_From_Sequence(seq_i);
        Plot_WD_Network(adjacency,[],group_colors);
        title(['Peak ' num2str(i)])
        sub_fig=sub_fig+1;
        
        % Convert directed adjacency matrix to vector
        adjacency_complete=zeros(n_nodes);
        adjacency_complete(1:length(adjacency),1:length(adjacency))=adjacency;
        adjacency_vector=adjacency_complete(:);
        adjacency_vectors(i,:)=adjacency_vector;
    end
    
    if(save)
        n_win=ceil(n_div/20);
        for i=1:n_win
            Hold_Figure(['Sequence graph - ' name ' (' num2str(i) ')' ]);
            Save_Figure(['Sequence graph - ' name ' (' num2str(i) ').png' ]);
        end
    end
end

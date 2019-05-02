% Get a directed adjacency matrix from a sequence
%
% Get a directed adjacency matrix including loops.
%
% Pérez-Ortega Jesús - march 2018 

function Adjacency = Get_Adjacency_From_Sequence(sequence)
    n=length(sequence);
    max_state=max(sequence);
    Adjacency=zeros(max_state);
    
    for i=1:n-1
        j=i+1;
        state_i=sequence(i);
        state_j=sequence(j);
        Adjacency(state_i,state_j)=Adjacency(state_i,state_j)+1;
    end
end    
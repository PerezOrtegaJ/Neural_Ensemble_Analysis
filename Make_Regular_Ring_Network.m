% Generate Ring Regular Network
%
% This function generates binary undirected network with ring regular
% connections.
%
% regular_network = Make_Regular_Ring_Network(N,K)
%
% Inputs:
% N = number of nodes
% K = number of links
%
% Outputs:
% Reg = binary undirected adjacent matrix of ring regular network
%
% ..:: by Jesús E. Pérez-Ortega ::.. March-2013
% Modified July-2018

function regular_network = Make_Regular_Ring_Network(N,K)
    k=2*K/N;
    regular_network=zeros(N);
    km=round(ceil(k)/2);
    for i=1:N
        n_b=i-[km:-1:1];
        n_a=i+[1:km];
        
        initial=find(n_b<1);
        if initial
            n_init=length(initial);
            n_b(1:n_init)=[N:-1:(N-n_init+1)];
        end
        
        final=find(n_a>N);
        if final
            n_final=length(final);
            n_a(end:-1:(end-n_final+1))=[1:n_final];
        end
        
        regular_network(i,[n_b, n_a])=1;
        regular_network([n_b, n_a],i)=1;
    end
    
    % Remove excess connections
    n_remove=(sum(sum(regular_network))-ceil(k*N))/2;
    [i,j]=find(triu(regular_network,2));
    idx=round(rand(1,n_remove)*length(i));
    for l=1:n_remove
        regular_network(i(idx(l)),j(idx(l)))=0;
        regular_network(j(idx(l)),i(idx(l)))=0;
    end
end
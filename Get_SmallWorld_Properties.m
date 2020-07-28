function properties = Get_SmallWorld_Properties(adjacency,only_connected)
% Get the Small-World properties
%
%       properties = Get_SmallWorld_Properties(adjacency,only_connected)
%
% Pérez-Ortega Jesús E.
% jul 2018
% modified Sep 18
% modified Jan 19

if nargin==1
    only_connected=false;
end

if only_connected
    nodes_connected=sum(adjacency)>0;
    adjacency=adjacency(nodes_connected,nodes_connected);
end

% Total nodes and total edges
N = length(adjacency);
Links = sum(adjacency);
K = sum(Links)/2;
K_mean = 2*K/N;
Kmax= N*(N-1)/2;
Rho = K/Kmax;

% Real
D=distance_bin(adjacency);              % distance
[L,E]=charpath(D);                      % characteristic path length and efficiency
Clocal=clustering_coef_bu(adjacency);   % local clustering coefficient
C=mean(Clocal);                         % clustering coefficient

% Regular
Reg=Make_Regular_Ring_Network(N,K);
Dreg=distance_bin(Reg);                 % distance   
[Lreg,Ereg]=charpath(Dreg);             % characteristic path length and efficiency    
Clocalreg=clustering_coef_bu(Reg);      % local clustering coefficient    
Creg=mean(Clocalreg);                   % clustering coefficient

% Red aleatoria
Rand=makerandCIJ_und(N,K);
Drand=distance_bin(Rand);               % distance       
[Lrand,Erand]=charpath(Drand);          % characteristic path length and efficiency        
Clocalrand=clustering_coef_bu(Rand);    % local clustering coefficient        
Crand=mean(Clocalrand);                 % clustering coefficient

% Medida de small-world
Omega=Lrand/L-C/Creg;

properties.N=N;
properties.K=K;
properties.K_mean=K_mean;
properties.Rho=Rho;
properties.Links=Links;

properties.Clocal=Clocal;
properties.C=C;
properties.L=L;
properties.E=E;

properties.Creg=Creg;
properties.Lreg=Lreg;
properties.Ereg=Ereg;

properties.Crand=Crand;
properties.Lrand=Lrand;
properties.Erand=Erand;

properties.Omega=Omega;
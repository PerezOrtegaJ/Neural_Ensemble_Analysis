function Plot_Small_World(adjacency,only_connected)
% Plot Small World properties
%
%       Plot_Small_World (adjacency,only_connected)
%
% Perez-Ortega Jesus, June 2019
% Modified Oct 2019

if nargin==1
    only_connected=false;
end

if only_connected
    nodes_connected=sum(adjacency)>0;
    adjacency=adjacency(nodes_connected,nodes_connected);
end

name = inputname(1);

% Get the Small-World properties
properties = Get_SmallWorld_Properties(adjacency,only_connected);

% Plot
Set_Figure(['Small world properties (' name ')'],[0 0 400 200])
plot(Scale([properties.Creg properties.C properties.Crand]),'or'); hold on
plot(Scale([properties.Lreg properties.L properties.Lrand]),'xb')
title([name ' | \omega = ' num2str(properties.Omega)])
set(gca,'xtick',1:3,'xticklabel',{'regular','real','random'})
legend({'C','L'})
xlim([0.5 3.5])
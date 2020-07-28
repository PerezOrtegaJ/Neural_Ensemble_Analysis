function Plot_Neurons_Measure(data,name,new_fig)
% Plot measure for neurons in vertical manner
%
%       Plot_Neurons_Measure(data,name,new_fig)
%
% By Jesus Perez-Ortega, June 2019

if nargin == 2
    new_fig = false;
end

if new_fig
    Set_Figure(name,[0 0 100 400]);
end

plot(data,'.-k')
view([90 -90]);xlim([1 length(data)])
ylabel(name)
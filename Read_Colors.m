function colors = Read_Colors(num_colors)
% Return the numbers of colors specified
%
%       colors = Read_Colors(num_colors)
%
% Perez-Ortega Jesus - May 2018

if nargin==0
    num_colors=10;
end

if(num_colors<=10)
    colors=[0.9 0.0 0.0;...         % red
             0.5 0.8 0.0;...        % green
             0.0 0.5 1.0;...        % sky blue
             0.9 0.9 0.0;...        % yellow
             0.9 0.0 0.9;...        % magenta
             0.0 0.9 0.9;...        % cyan
             1.0 0.5 0.0;...        % orange 
             0.5 0.0 1.0;...        % purple
             1.0 0.7 0.7;...        % rose
             0.6 0.3 0.0;...        % brown
             0.95 0.5 0.5;...       % red light
             0.75 0.9 0.5;...       % green light
             0.5 0.75 1.0;...       % sky blue light
             0.95 0.95 0.5;...      % yellow light
             0.95 0.5 0.95;...      % magenta light
             0.5 0.95 0.95;...      % cyan light
             1.0 0.75 0.5;...       % orange light
             0.75 0.5 1.0;...       % purple light
             1.0 0.85 0.85;...      % rose light
             0.8 0.65 0.5;...       % brown light
             0.4 0.0 0.0;...        % red dark
             0.0 0.3 0.0;...        % green dark
             0.0 0.0 0.5;...        % sky blue dark
             0.4 0.4 0.0;...        % yellow dark
             0.4 0.0 0.4;...        % magenta dark
             0.0 0.4 0.4;...        % cyan dark
             0.5 0.0 0.0;...        % orange dark
             0.0 0.0 0.5;...        % purple dark
             0.5 0.2 0.2;...        % rose dark
             0.2 0.1 0.0];          % brown dark
    colors=colors(1:num_colors,:);
else
    colors=hsv(num_colors);
end
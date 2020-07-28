function data_out = Scale(data,min_value,max_value)
% Scale data between 0 and 1
%
%       data_out = Scale(data,min_value,max_value)
%
% Jesus Perez-Ortega April-19

if nargin==1
    min_value = 0;
    max_value = 1;
end

% Change to double
data_out = double(data);

% Substract minimum
min_data = min(data_out(:));
data_out = data_out-min_data;

% Divide by maximum
max_data = max(data_out(:));
if max_data
    data_out = data_out./max_data;

    % Multiply by factor
    factor = max_value-min_value;
    data_out = data_out.*factor;

    % Add minimum
    data_out = data_out+min_value;
else
    data_out = min_value*ones(size(data));
end




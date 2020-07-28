function raster = Get_Raster_From_MEA_Units(window_ms)
% Build a raster from Multi-Electrode Array (MEA) units
%
% Read units from the workspace. Each variable is a vector indicating the
% time stamps. The raster is binarized by the window defined.
%
%       raster = Get_Raster_From_MEA_Units(window_ms)
%
%       default: window_ms = 1;
% 
% Perez-Ortega Jesus - June 2019

if nargin==0
    window_ms = 1;
end

units_names = evalin('base','who');
n_units = length(units_names);

% Get the time length of the raster
max_time = 0;
for i = 1:n_units
    max_i = evalin('base',['max(' units_names{i} ');']);
    if max_i>max_time
        max_time = max_i;
    end
end
max_time = ceil(max_time)*1000;

% Set raster size
raster = zeros(1,max_time,'logical');

% Build raster
k=1;
for i = 1:n_units
    time_stamps_unit = evalin('base',[units_names{i} ';']);
    spikes_id = round(time_stamps_unit*1000/window_ms)+1;
    if ~isnan(spikes_id)
        raster(k,spikes_id) = true;
    end
    k=k+1;
end
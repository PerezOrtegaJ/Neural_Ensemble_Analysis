function h = Set_Axes(AxesName,Position)
% Set Axes
%
%       h = Set_Axes(AxesName,Position)

ax = axes('outerposition',Position);
set(ax,'Tag',AxesName)

if nargout
    h = ax;
end
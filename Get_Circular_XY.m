function [xy,step] = Get_Circular_XY(n,radio,offset)
% Get circular coordinates for n elements given a radio and offset in
% degrees
%
%       [xy,step] = Get_Circular_XY(n,radio,offset)
%
% Perez-Ortega Jesus - April 2018
% modified April 2019

switch(nargin)
    case 1
        radio = 1;
        offset = 0;
    case 2
        offset = 0;
end

% convert to radians
offset = offset*pi/180;

if (n==1)
    xy=[0 0];
    step = 0;
else
    xy=[cos(offset+2*pi*(1:n)'/n) sin(offset+2*pi*(1:n)'/n)].*radio;
    step = 360/n;
end
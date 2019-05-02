function mask = Circle_Mask(image_size,xy_center,radius)
% Create a circle mask
%
% Jesus Perez-Ortega, jesus.epo@gmail.com
% March, 2019

% Get size of image
h = image_size(1);
w = image_size(2);
[x,y] = meshgrid(1:w,1:h);

% Get mask
mask = sqrt((x-xy_center(1)).^2 + (y-xy_center(2)).^2) < radius;
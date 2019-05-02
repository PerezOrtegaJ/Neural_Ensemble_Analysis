% Set colormap blue-white-red
%
% By Jesús Pérez-Ortega jan-2018

function Set_Colormap_Blue_White_Red()
    bluemap=colormap(gray(32))+repmat([0 0 1],32,1);
    bluemap(bluemap>1)=1;
    redmap=colormap(flipud(gray(32)))+repmat([1 0 0],32,1);
    redmap(redmap>1)=1;
    colormap(gca,[bluemap;redmap])
end
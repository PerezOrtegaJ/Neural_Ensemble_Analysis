function Save_Figure(name,format,path) 
% Save current figure with default style
%
%       Save_Figure(name,format,path) 
%
% Perez-Ortega Jesus - June 2018
% modified Feb 2019
% modified May 2019

switch nargin
    case 1
        s.Format = 'png';
        path = '';
    case 2
        s.Format = format;
        path = '';
    case 3
        s.Format = format;
end
s.Version='1';
s.Preview='none';
s.Width='auto';
s.Height='auto';
s.Units='inches';
s.Color='rgb';
s.Background='w';
s.FixedFontSize='14';
s.ScaledFontSize='auto';
s.FontMode='fixed';
s.FontSizeMin='8';
s.FixedLineWidth='1';
s.ScaledLineWidth='auto';
s.LineMode='none';
s.LineWidthMin='0.5';
s.FontName='auto';
s.FontWeight='auto';
s.FontAngle='auto';
s.FontEncoding='latin1';
s.PSLevel='3';
s.Renderer='auto';
s.Resolution='300';
s.LineStyleMap='none';
s.ApplyStyle='0';
s.Bounds='loose';
s.LockAxes='on';
s.LockAxesTicks='off';
s.ShowUI='on';
s.SeparateText='off';

if strcmp(s.Format,'eps')
    set(gcf,'renderer','Painters')
    print('-depsc','-tiff','-r300', '-painters', [path name '.eps'])
else
    hgexport(gcf,[path name '.' s.Format ],s);
end
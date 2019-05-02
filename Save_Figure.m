% Save current figure with default style
%
% Pérez-Ortega Jesús - June 2018
% modified Feb 2019
function Save_Figure(name,format) 
    
    if (nargin==1)
        s.Format = 'png';
    else
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
    s.Resolution='auto';
    s.LineStyleMap='none';
    s.ApplyStyle='0';
    s.Bounds='loose';
    s.LockAxes='on';
    s.LockAxesTicks='off';
    s.ShowUI='on';
    s.SeparateText='off';
    
    hgexport(gcf,[name '.' s.Format ],s);
end
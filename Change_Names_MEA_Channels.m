% Exclusivo para MEAs de 128 canales

function new_channels = Change_Names_MEA_Channels(channels)
    
    ch=channels(:,1);
    ends=[find(diff(ch)~=0); length(ch)];
    inis=[1; ends(1:end-1)+1];
    
    for i=1:length(inis)
       new(inis(i):ends(i))=i;
    end
    
    channels(:,1)=new;
    new_channels=channels;
end
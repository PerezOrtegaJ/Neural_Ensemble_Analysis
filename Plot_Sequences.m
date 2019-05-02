% Plot all sequences in vertical way
%
% Pérez-Ortega Jesús - May 2018

function Plot_Sequences(sequences,division_ms,save,name,colors)
    n_colors=max(sequences(:));
    default_colors= Read_Colors(n_colors);
    if(nargin==2)
        save=false;
        name='Sequences';
        colors=default_colors;
    elseif(nargin==3)
        name='Sequences';
        colors=default_colors;
    elseif(nargin==4)
        colors=default_colors;
    end

    [n,n_in_seq]=size(sequences);
    
    if(division_ms*n_in_seq>=3000)
        times=(division_ms:division_ms:division_ms*n_in_seq)/1000;
    elseif(division_ms==0)
        times=1:n_in_seq;
    else
        times=division_ms:division_ms:division_ms*n_in_seq;
    end
    
    Set_Figure(name,[0 0 900 200]);
    map=winter(n);
    for i=1:n
        plot(times,sequences(i,:)+1*i,'color',map(i,:));hold on
    end
    
    sequence_mode=mode(sequences);
    errors=0;
    for i=1:n_in_seq
        errors=errors+length(find(sequences(:,i)~=sequence_mode(i)));
    end
    
    if(division_ms*n_in_seq>=3000)
        xlabel('time (s)')
    elseif(division_ms==0)
        xlabel('peak # (t)')
    else
        xlabel('time (ms)')
    end
    ylabel('sequence #')
    
    errors_percetage=errors/(n*n_in_seq)*100;
    
    title([name ' - ' num2str(errors) ' errors from the mode - '...
        num2str(errors_percetage) '%'])
    
    % to save
    if(save)
        Save_Figure(name);
    end
    
    % Sequences in image
    Set_Figure([name ' - image'],[0 0 1000 800]);
    imagesc(sequences)
    colormap(colors)
    title([name ' - ' num2str(errors) ' errors from the mode - '...
        num2str(errors_percetage) '%'])
    
    % to save
    if(save)
        Save_Figure([name ' - image']);
    end
end
% Jitter a raster with an specific bin
%
% Jes?s P?rez-Ortega - Sep 2018

function jittered = Jitter_Raster(raster,bin,exact_bin)
    if(nargin==2)
        exact_bin=false;
    end
    
    [n_cells,n_samples]=size(raster);
    
    jittered=zeros(n_cells,n_samples);    
    for i=1:n_cells
        cell=raster(i,:);
        
        t=find(cell);

        jit=rand(1,length(t));
        if(exact_bin)
            jit(jit>0.5)=bin;
            jit(jit<=0.5)=-bin;
        else
            jit=round(jit*2*bin)-bin;
        end

        t_jit=t+jit;
        t_jit=sort(t_jit);
        
        if(max(t_jit)>n_samples)
            n_extra=length(find(t_jit>n_samples));
            t_jit=t_jit(1:end-n_extra);
        end
        
        if(min(t_jit)<1)
            n_extra=length(find(t_jit<1));
            t_jit=t_jit(1+n_extra:end);
        end
        
        jittered(i,t_jit)=1;
            
    end
end
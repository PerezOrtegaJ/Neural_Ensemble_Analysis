% Get network activation sequence
%
% Jesús Pérez-Ortega - Dic 2018
% modified Jan 2019
function [sequence,singles] = Get_Network_Activation_Sequence(raster,network,link_sequence)

    if(nargin==2)
        link_sequence = false;
    end

    %[shorted,short_times]=Delete_Consecutive_Coactivation(raster);
    n_length=size(raster,2);
    adjacency=Get_Adjacency_From_Raster(raster,'coactivity');
    coincidence=double(adjacency>0).*network;
    
    if(link_sequence)
        coincidence = squareform(coincidence,'tovector');
    end
    
    %total_links=sum(adjacency_core_inspiration(:));
    %n_co=1;
    %single_links=0;

    sequence=[];
    for i=1:n_length
        single=Get_Adjacency_From_Raster(raster(:,i),'coactivity');
        if(link_sequence)
            single=squareform(single,'tovector');
        end
        single_coincidence=single.*coincidence;        
        sequence=[sequence setdiff(find(sum(single_coincidence)),sequence)];
        singles{i}=single_coincidence;
        
        % Plot network
        %{
        core_coactivation=single.*adjacency_core_inspiration;
        single_links=single_links+sum(coactivation_remaining(:));
        
        if(sum(coactivation_remaining(:))~=0)
            %Set_Figure('Network',[0 0 300 300]);
            net_color=colors(short_times(l),:);
            node_size=10;
            subplot(5,11,n_co+11*(m-1))
            %Plot_WU_Network(core_coactivation,[],net_color,mean([net_color; 0.5 0.5 0.5]),node_size); hold on
            Plot_WU_Network(coactivation_remaining,[],net_color,mean([net_color; 0.5 0.5 0.5]),node_size)
            title([num2str(short_times(l)) ' ms (' num2str(round(single_links/total_links*100)) '%)'])
            if(n_co==1)
                ylabel(['inspiration #' num2str(k)])
            end
            subplot(5,11,11*m)
            Plot_WU_Network(coactivation_remaining,[],net_color,mean([net_color; 0.5 0.5 0.5]),node_size);hold on
    %                     frame = getframe(gcf);
    %                     writeVideo(v,frame);
            n_co=n_co+1;
            if(n_co>10)
                break;
            end
        end
        remaining=remaining-coactivation_remaining;
        if(remaining==0)
            break;
        end
        %input('press any key to continue...')
        %}
    end
    %{
    m=m+1;
    if(m>5)
        Save_Figure(['Networks_' num2str(j) '_' num2str(ceil(k/5))]);
        close
        m=1;
    end
    %}
end
% Times comparison  Manual VS Auto

function [coincidence,diffs] = Compare_Times(times_1,times_2,coactivity)
    if(nargin==2)
        coactivity=[];
    end
    
    n_1=size(times_1,1);
    n_2=size(times_2,1);
    Times_1=times_1(:);
    Times_2=times_2(:);

    Y_manual=1.5*ones(length(Times_1),1);
    Y_auto=1.5*ones(length(Times_2),1);

    % Comparison
    n_coincidence=0;
    auto_extra=0;
    manual_extra=0;
    auto_actual=1;
    coincidence=[];
    for i=1:n_1
        i_m=times_1(i,1);
        f_m=times_1(i,2);

        for j=auto_actual:n_2
            i_a=times_2(j,1);
            f_a=times_2(j,2);

            % If data is in the same place
            %if(i_m>=i_a && i_m<=f_a || f_m>=i_a && f_m<=f_a || i_m<=i_a && f_m>=f_a)
            if abs(i_m-i_a)<100
                diff_i=i_a-i_m;
                diff_f=f_a-f_m;
                n_coincidence=n_coincidence+1;
                coincidence(n_coincidence,:)=[i_m i_a f_m f_a];
                diffs(n_coincidence,:)=[diff_i diff_f];
                auto_actual=j+1;
                break;
            % If are differents
            elseif(i_m>f_a)
                auto_extra=auto_extra+1;
            elseif(f_m<i_a)
                manual_extra=manual_extra+1;
                auto_actual=j;
                break;
            end
        end
    end
    
%     Set_Figure('Errors in initial and final times',[0 0 1000 600]);
%     subplot(2,1,1)
%     hist(diffs(:,1))
%     xlabel('time (ms)')
%     title(['Error distribution in initial times (mean ' num2str(mean(diffs(:,1)))...
%         ' std ' num2str(std(diffs(:,1))) ')'])
%     subplot(2,1,2)
%     hist(diffs(:,2))
%     xlabel('time (ms)')
%     title(['Error distribution in final times (mean ' num2str(mean(diffs(:,2)))...
%         ' std ' num2str(std(diffs(:,2))) ')'])
    
%     s=hgexport('readstyle','A_default');
%     s.Format = 'png';
%     hgexport(gcf,'Histograms.png',s);
    
    if (coactivity)
        % Plot
        Set_Figure('Coactivity with initial and final times',[0 0 1000 300]);
        plot(coactivity,'k'); hold on
        plot(Times_1,Y_manual,'or')
        plot(Times_2,Y_auto,'xb')
        legend({'Coactivity','manual','auto'})

        Y_coincidence=2.5*ones(n_coincidence,1);
        % Plot manual
        plot(coincidence(:,1),Y_coincidence,'og')
        plot(coincidence(:,3),Y_coincidence,'og')
        % Plot auto
        plot(coincidence(:,2),Y_coincidence,'xg')
        plot(coincidence(:,4),Y_coincidence,'xg')

        title(['manual: ' num2str(length(times_1)) ' ( ' num2str(manual_extra) ' extras) - auto: ' num2str(length(times_2)) ' ( ' num2str(auto_extra) ' extras)'])
        
%         s=hgexport('readstyle','A_default');
%         s.Format = 'png';
%         hgexport(gcf,'Coactivity with times.png',s);
    end
end
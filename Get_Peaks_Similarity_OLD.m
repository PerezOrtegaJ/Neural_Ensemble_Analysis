% Similarity Index
%
% Get the peaks from coactivity and compute similarity between peaks 
%
% By Jesús Pérez-Ortega jan-2018
% modified march-2018

function [Sim PeaksIdx DataPeaks] = Get_Peaks_Similarity_OLD(Data,Smooth_Co,Th,Join,Binary,Sim_method)
    
    % Find peaks
    PeaksIdx=FindPeaks_JP(Smooth_Co,Th,Join);
    n_peaks=max(PeaksIdx);
    
    if (n_peaks)
        switch(Sim_method)
            case 'RV'   % 2h
                peaks=max(PeaksIdx);

                C=size(Data,1);
                DataPeaks3=zeros(C,C,peaks);
                DataPeaks3_2=zeros(C,C,peaks);

                for i=1:peaks
                    I=Data(:,PeaksIdx==i);
                    DataPeaks3(:,:,i)=I*I';
                end
                for i=1:peaks
                    Trace_DataPeaks3(i)=trace(abs(DataPeaks3(:,:,i)^2));
                end
                Sim=eye(peaks);
                for i=1:(peaks-1)
                    for j=(i+1):peaks
                        Sim(i,j) = trace(DataPeaks3(:,:,i)*DataPeaks3(:,:,j))/sqrt(Trace_DataPeaks3(i)*Trace_DataPeaks3(j));
                        Sim(j,i) = Sim(i,j);
                    end
                end
                Sim=(Sim+1)/2; % Normalization
            case 'Network Hamming Coactivity' % 5min
                peaks=max(PeaksIdx);
                for i=1:peaks
                    P=Data(:,PeaksIdx==i);
                    A=Get_Adjacency_From_Raster(P>0,'Coactivity');
                    A=A/size(P,2);
                    A(A<1)=0;
                    As(i,:)=squareform(A,'tovector');
                end
                Distance=squareform(pdist(As,'Hamming'));
                Sim=1-Distance;
            case 'Network Pearson Euclidean' %5min
                peaks=max(PeaksIdx);
                for i=1:peaks
                    P=Data(:,PeaksIdx==i);
                    A=Get_Adjacency_From_Raster(P,'Pearson');
                    As(i,:)=squareform(A,'tovector');
                end
                Distance=squareform(pdist(As,'Euclidean'));
                Sim=1-Distance/max(Distance(:));
            case 'Network Pearson-Size Euclidean' % 5min
                peaks=max(PeaksIdx);
                for i=1:peaks
                    P=Data(:,PeaksIdx==i);
                    A=Get_Adjacency_From_Raster(P,'Pearson')*size(P,2);
                    A(A<0)=0;
                    As(i,:)=squareform(A,'tovector');
                end
                Distance=squareform(pdist(As,'Euclidean'));
                Sim=1-Distance/max(Distance(:));
            case 'Network Pearson-Size Euclidean' % 5min
                % Convert to binary if needed
                DataPeaks=PeaksVectors_JP(Data,PeaksIdx,Binary);

                % Similarity
                Distance=squareform(pdist(DataPeaks,Sim_method));
                Sim=1-Distance/max(Distance(:)); % Normalization
            otherwise
                % Convert to binary if needed
                DataPeaks=PeaksVectors_JP(Data,PeaksIdx,Binary);

                % Similarity
                Distance=squareform(pdist(DataPeaks,Sim_method));
                Sim=1-Distance/max(Distance(:)); % Normalization
        end
    end
end
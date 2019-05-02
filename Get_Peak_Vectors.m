% Get Peak Vectors
% Join the vectors of the same peak.
%
% [XPeaks] = PeaksVectors_JP(X,Xid,mode)
%
% Inputs
% Data                  = data as F x C matrix (F = #frames, C = #cells)
% PeaksIdx              = Fx1 vector containing the peaks indexes
% Vector_method         = choose the method for build the vetor
% Connectivity_Method   = connectivity method is used in case of
%                         'Vector_method' is 'network'
% 
% Outputs
% DataPeaks = data as matrix PxC (P = #peaks)
%
% Pérez-Ortega Jesús E. - March 2018
% Modified Nov 2018

function vectors = Get_Peak_Vectors(data,peak_indices,vector_method,connectivity_method,bin_network)
    if(nargin==4)
        bin_network = 1;
    elseif(nargin==3)
        connectivity_method = 'none';
        bin_network = 1;
    end

    peaks=max(peak_indices);
    if(peaks)
        C=size(data,1);
        switch(vector_method)
            case 'sum'
                vectors=zeros(peaks,C);
                for i=1:peaks
                    DataPeak_i=data(:,peak_indices==i);
                    vectors(i,:)=sum(DataPeak_i,2);
                end
            case 'binary'
                vectors=zeros(peaks,C);
                for i=1:peaks
                    DataPeak_i=data(:,peak_indices==i);
                    vectors(i,:)=sum(DataPeak_i,2)>0;
                end
            case 'average'
                vectors=zeros(peaks,C);
                for i=1:peaks
                    DataPeak_i=data(:,peak_indices==i);
                    vectors(i,:)=mean(DataPeak_i,2);
                end
            case 'network'
                vectors=zeros(peaks,C*(C-1)/2);
                for i=1:peaks
                    DataPeak_i=data(:,peak_indices==i);
                    A=Get_Adjacency_From_Raster(Reshape_Raster(DataPeak_i,bin_network),...
                        connectivity_method);
                    
                    % Get significant network
                    %{
%                     extra=250;
%                     id = find(peak_indices==i);
%                     id = id(1)-extra:id(end)+extra;
%                     DataPeak_i = data(:,id);
                    iterations = 20;
                    alpha = 0.05;
                    single_th = true;
                    shuffle_method = 'time_shift';
                    A = Get_Significant_Network_From_Raster(DataPeak_i,bin_network,iterations,...
                        alpha,connectivity_method,shuffle_method,single_th);
                    %}
                    vectors(i,:)=squareform(A,'tovector');
                end
        end
    else
        disp('There are no data peaks!')
    end
end

%{
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
                        Sim(i,j) = trace(DataPeaks3(:,:,i)*DataPeaks3(:,:,j))/...
                            sqrt(Trace_DataPeaks3(i)*Trace_DataPeaks3(j));
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
                DataPeaks=PeaksVectors_JP(Data,PeaksIdx,Vector_method);

                % Similarity
                Distance=squareform(pdist(DataPeaks,Sim_method));
                Sim=1-Distance/max(Distance(:)); % Normalization
            otherwise
                % Convert to binary if needed
                DataPeaks=PeaksVectors_JP(Data,PeaksIdx,Vector_method);

                % Similarity
                Distance=squareform(pdist(DataPeaks,Sim_method));
                Sim=1-Distance/max(Distance(:)); % Normalization
        end
    end
    %}

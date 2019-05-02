% Davies-Bouldin Index
% Get the Davies-Bouldin Index for g groups given a distance matrix.
%
% [DBI] = DaviesIdx_JP(g,dist,idx)
%
% Inputs
% g = number of groups
% Xp = binary data as matrix PxC (P = #peaks, C = #cells)
% dis = square distance matrix
% idx = indexes of group to which each data point belongs
% 
% Outputs
% DBI = Davies-Bouldin index
%
% ..:: by Jesús E. Pérez-Ortega ::.. Mar-2012

function [DBI] = DaviesIdx_JP(g,Xp,idx)

db=zeros(g);
for i=1:g-1
    
    g_i=find(idx==i);           % index of ith group
    c_i=mean(Xp(g_i,:),1);        % centroid of ith group
    
    c_i_rep=repmat(c_i,numel(g_i),1);
    s_i=mean(sqrt(sum((c_i_rep-Xp(g_i,:)).^2,2))); % standard deviation of ith group
    
    for j=i+1:g
        
        g_j=find(idx==j);       % index of jth group
        c_j=mean(Xp(g_j,:));    % centroid of ith group
        c_j_rep=repmat(c_j,numel(g_j),1);
        s_j=mean(sqrt(sum((c_j_rep-Xp(g_j,:)).^2,2))); % standard deviation of ith group
        
        d_ij=sqrt(sum((c_i-c_j).^2)); % Distance Between centroids
        
        db(i,j)=(s_i+s_j)/d_ij;
        db(j,i)=(s_i+s_j)/d_ij;
    end
end

DBI=sum(max(db))/g;




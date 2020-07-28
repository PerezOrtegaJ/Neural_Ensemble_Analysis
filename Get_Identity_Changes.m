function proportionsAB = Get_Identity_Changes(structureA,structureB)
% Get proportions of identity changes between two ensemble structures
%
%       proportionsAB = Get_Identity_Changes(structureA,structureB)
%
% By Jesus Perez-Ortega, May 2020

nEnsembles = size(structureA,1);
nEnsemblesB = size(structureB,1);

if nEnsembles==nEnsemblesB
    for i = 1:nEnsembles
        idA = structureA(i,:)>0;
        idB = structureB(i,:)>0;
        
        % Get active in both A and B
        proportionsAB(1,i) = nnz(idA&idB);
        
        % Get active only in A but not in B
        proportionsAB(2,i) = nnz((idA-idB)>0);
        
        % Get active only in B but not in A
        proportionsAB(3,i) = nnz((idB-idA)>0);
        
        % Get proportions
        proportionsAB(:,i) = proportionsAB(:,i)/sum(proportionsAB(:,i));
    end
else
    error('Structures A and B need to have the same number of ensembles')
end

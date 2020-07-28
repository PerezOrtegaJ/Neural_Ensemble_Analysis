function newSequence = Change_Sequence_Numbers(sequence,new)
% Replace the numbers of the sequence by the new numbers given
%
%       newSequence = Change_Sequence_Numbers(sequence,new)
%
% By Jesus Perez-Ortega, Jun 2020

nSeq = length(unique(sequence));
nNew = length(unique(new));

if nSeq == nNew
    if iscolumn(new)
        new = new';
    end
    newSequence = zeros(size(sequence));
    j = 1;
    for i = new
        newSequence(sequence==i) = j;
        j = j+1;
    end
else
    error(['number of elements in "new" variable are not the same number os elements'...
    'in "sequence" variable'])
end
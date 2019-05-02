% Get groups of neurons
%
% By Jesús Pérez-Ortega jan-2018

function [CellsGroups Indexes IndexesComb] = Get_Groups_Of_Neurons(Freqs,Groups,idx_vector_state,th_freq_group)
    
    % Get states of each neuron
    C=size(Freqs,1);
    CellsGroups=zeros(Groups,C);
    CellsAcGroups=zeros(Groups,C);
    for i=1:Groups
        PeaksGroupIdx= idx_vector_state==i;
        n_peaks_group=length(PeaksGroupIdx);
        CellsAcGroups(i,:)=sum(Freqs(:,PeaksGroupIdx),2)/n_peaks_group;
        CellsGroup=CellsAcGroups(i,:)>th_freq_group;
        CellsGroups(i,CellsGroup)=i;
    end
    
    % Get states combinations  
    [Groups C]=size(CellsGroups);
    States=[]; Labels={};
    Idx=[]; Indexes=[];
    Combinations=2^Groups-1;
    for i=1:Combinations
        bin_number=dec2bin(i,Groups);
        GroupsToCompare=[];
        Label=[];
        for j=1:Groups
            Compare=str2num(bin_number(j));
            if Compare
                GroupsToCompare=[GroupsToCompare; CellsGroups(j,:)>=1];
                if Label
                    Label=[Label ',' num2str(j)];
                else
                    Label=num2str(j);
                end
            else
                GroupsToCompare=[GroupsToCompare; CellsGroups(j,:)==0];
            end
        end
        Idx{i}=find(sum(GroupsToCompare,1)==Groups);
        States(i)=length(Idx{i})/C;
        Labels(i)={Label};
    end
    [Labels idxSort]=sort(Labels);
    States=States(idxSort);
    for i=1:Combinations
        Indexes=[Indexes Idx{idxSort(i)}];
        IndexesComb(Idx{i})=i;
    end
end
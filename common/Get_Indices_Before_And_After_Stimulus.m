function indices = Get_Indices_Before_And_After_Stimulus(stimulus,before_samples,after_samples)
% Get the indices befor and after and stimulus 
%
%       indices = Get_Indices_Before_And_After_Stimulus(stimulus,before_samples,after_samples)
%
% Jesus Perez-Ortega May 2019

during = stimulus>0; 
before = Bin_Signal(during,before_samples,'before');
after = Bin_Signal(during,after_samples,'after');
indices = find(before | during' | after);
    
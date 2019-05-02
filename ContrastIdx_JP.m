% Contrast index
% Get the Contrast index for g groups given a similarity matrix.
% (Michelson contrast 1927, Plenz 2004)
%
% [CstIdx] = ContrastIdx_JP(g,sim,idx)
%
% Inputs
% g = number of groups
% sim = similarity as matrix PxP (P = #peaks)
% idx = indexes of group to which each data point belongs
% 
% Outputs
% CstIdx = Contrast index

% ..:: by Jesús E. Pérez-Ortega ::.. April-2012

function [CstIdx] = ContrastIdx_JP(g,sim,idx)

simC=sim-diag(diag(sim));

s_i=0;
s_o=0;
p_i=0;
p_o=0;
for i=1:g
    g_i=find(idx==i);
    g_o=find(idx~=i);

    s_i=s_i+sum(sum(simC(g_i,g_i)));  % sum intra-group
    s_o=s_o+sum(sum(simC(g_i,g_o))); % sum others

    p_i=p_i+numel(g_i)^2;
    p_o=p_o+numel(g_i)*numel(g_o);
end
Di=s_i/p_i;
Do=s_o/p_o;

CstIdx=(Di-Do)/(Di+Do);

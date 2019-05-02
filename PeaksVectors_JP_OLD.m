% Peaks Vectors
% Join the vectors of the same peak.
%
% [XPeaks] = PeaksVectors_JP(X,Xid,mode)
%
% Inputs
% X = data as F x C matrix (F = #frames, C = #cells)
% Xid = Fx1 vector containing the peaks indexes
% sumMode = set 1 if you want to sum the activity or set 0 if you only want
%           binary data
% 
% Outputs
% XPeaks = data as matrix PxC (P = #peaks)
%
% ..:: by Jesús E. Pérez-Ortega ::.. Jun-2012
%
% V 2.0 3rd input added: 'sumMode' (binary or sum) jun-2012
% modified march-2018

function [XPeaks] = PeaksVectors_JP_OLD(X,Xid,binary)

C=size(X,1);
peaks=max(Xid);

XPeaks=zeros(peaks,C);
for i=1:peaks
    peak_n=find(Xid==i);
    XPeak=X(:,peak_n);
    XPeaks(i,:)=sum(XPeak,2);
    if binary
        XPeaks(i,:)=XPeaks(i,:)&1;
    end
end

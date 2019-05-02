% RV coefficient
% 
% Compare the correlation between matrices of differents column size.
% tr(XX'YY')/sqrt(tr((XX')^2)*tr((YY')^2))
%
% Pérez-Ortega Jesús march-2018

function RV = RV_coefficient(X,Y)
    XX=X*X';
    YY=Y*Y';
    RV=trace(XX*YY)/sqrt(trace(abs(XX^2))*trace(abs(YY^2)));
end
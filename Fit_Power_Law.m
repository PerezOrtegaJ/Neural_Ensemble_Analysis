% Fit_Power_Law
%
% Jesús E. Pérez-Ortega - june 2018

function [slope, intercept, R2] = Fit_Power_Law(x,y)
    
    % Set power law function
    power_law = fittype('a*x^b'); 
    
    % Compute fit
    [fit1,gof] = fit(x,y,power_law,'StartPoint',[1 -1]);
    coeffs = coeffvalues(fit1);

    % Get coefficients
    slope=coeffs(2);
    intercept=coeffs(1);
    R2=gof.rsquare;
end

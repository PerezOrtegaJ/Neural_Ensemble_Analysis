% Find the threshold upper a given alpha
%
% Jesús Pérez-Ortega nov 2018

function th = Find_Threshold_In_Cumulative_Distribution(data,alpha)
    
    if(min(data)==max(data))
       th = max(data)+1; 
    else
        if(max(data)<=1)
            x = 0:0.001:1;
        elseif(max(data)<=10)
            x = 0:0.01:10;
        else
            x = 0:max(data);
        end
        y = hist(data,x);
        cdy = cumsum(y);
        cdy = cdy/max(cdy);
        id = find(cdy>(1-alpha),1,'first');
        th = x(id);
    end
end
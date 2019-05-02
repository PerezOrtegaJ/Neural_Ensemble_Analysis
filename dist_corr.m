function d = dist_corr(x,y)
    A=x-mean(x);
    B=y-mean(y);
    
    d = 1 - sum(A.*B)/sqrt(sum(A.*A).*sum(B.*B));
end
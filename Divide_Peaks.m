% Divide peak indices in bin
% 
% By Jesús Pérez-Ortega april-2018

function peak_indices_divided = Divide_Peaks(peak_indices, bin)
    peak_indices_divided=peak_indices;
    peaks=max(peak_indices);
    peak_i=1;
    for i=1:peaks
        peak=find(peak_indices==i);
        if(~isempty(peak))
            n_divs=ceil(length(peak)/bin);
            for j=1:n_divs
                ini=peak((j-1)*bin+1);
                if(j==n_divs)
                    fin=peak(end);
                else
                    fin=peak(j*bin);
                end
                peak_indices_divided(ini:fin)=peak_i;
                peak_i=peak_i+1;
            end
        end
    end
end
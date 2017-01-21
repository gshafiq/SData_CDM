function [x_peak_adj, y_peak_adj] = peak_adj2(x_peaks, y_peaks)
%checks for first and last peaks to match the number of peaks
% Signal is x, ECG is y

x_peak_adj = x_peaks; y_peak_adj = y_peaks;
if length(x_peaks)~=length(y_peaks)
    %in case of first extra peak
    if (y_peaks(1)-x_peaks(1))>(x_peaks(2)-y_peaks(1)) % extra signal peak
        x_peak_adj(1) = [];
    elseif (x_peaks(1)-y_peaks(1))>(y_peaks(2)-x_peaks(1)) %extra ecg peak
        y_peak_adj(1) = [];
    end
    
    %in case of last extra peak
    
    if (y_peaks(end)-x_peaks(end))>(x_peaks(end)-y_peaks(end-1)) %extra ECG
        y_peak_adj(end) = [];
    elseif (x_peaks(end)-y_peaks(end))>(y_peaks(end)-x_peaks(end-1)) %extra Signal peak
        x_peak_adj(end) = [];
    end
    
    
end
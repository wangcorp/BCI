function [ data_filtered ] = FilterFreq( data )
%BUTTERING filtering
%   Applies butter filter on data

[b,a] = butter(2,([1,40]*2)/512);
data_filtered = filter(b,a,data(:,1:16));
%data_filtered = [data_filtered zeros(length(data_filtered),1) data(:,end)];

end


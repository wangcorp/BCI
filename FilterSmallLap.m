function [ data_lap_small ] = FilterSmallLap( data, lap )
%LSMALL_LAP_FILTERING filters spatially the input data by a small laplacian
%   Substractes mean of neighboring electrodes

data_lap_small = data(:,1:16)*lap;
%data_lap_small = [data_lap_small zeros(length(data),1) data(:,end)];

end


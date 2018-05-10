function [ data_car ] = FilterCar( data )
%CAR_FILTERING applies spatial car filtering
%   Car filtering substracts mean of all electrodes for each electrodes

data_mean = mean(data(:,1:16),2);
data_car = data(:,1:16) - repmat(data_mean,1,16);
%data_car = [data_car zeros(length(data),1) data(:,end)];

end


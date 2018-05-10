function [ filtered_data ] = FilterCar3D( data3 )
%FILTERCAR3D filters multiple trials in an array
%   well well well

filtered_data = zeros(size(data3));

for i=1:size(data3,3)
    filtered_data(:,:,i) = FilterCar(data3(:,:,i));
end

end


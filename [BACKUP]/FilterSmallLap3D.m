function [ filtered_data ] = FilterSmallLap3D( data3,lap )
%FILTERSMALLLAP3D filters multiple trails in an array
%   well well well

filtered_data = zeros(size(data3));

for i=1:size(data3,3)
    filtered_data(:,:,i) = FilterSmallLap(data3(:,:,i),lap);
end

end


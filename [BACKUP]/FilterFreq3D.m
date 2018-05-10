function [ filtered_data ] = FilterFreq3D( data3 )
%FILTERFREQ3D filters multiple trials in an array
%   well well well

filtered_data = zeros(size(data3));

for i=1:size(data3,3)
    filtered_data(:,:,i) = FilterFreq(data3(:,:,i));
end

end


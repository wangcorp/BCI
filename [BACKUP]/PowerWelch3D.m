function [ welch_value ] = PowerWelch3D( data3 )
%POWERWELCH3D Summary of this function goes here
%   Detailed explanation goes here

welch_value = zeros(129, size(data3,2), size(data3,3));

for i=1:size(data3,3)
    welch_value(:,:,i) = pwelch(data3(:,:,i),256,128,[],512);
end

end


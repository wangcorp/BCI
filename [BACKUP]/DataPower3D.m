function [ pdata3 ] = DataPower3D( data3 )
%DATAPOWER3D returns the power of the data frequencies for each trials
%   well well well

pdata3 = zeros(size(data3));

for i=1:size(data3,3)
   pdata3(:,:,i) = data3(:,:,i).^2; 
end

end


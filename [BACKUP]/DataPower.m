function [ pdata ] = DataPower( data )
%DATA_POWER returns the power of the data frequencies
%   Squares the values of the signal to find frequencies power

pdata = data(:,1:16).^2;

end


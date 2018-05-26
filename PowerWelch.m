
function [ welch_value, f ] = PowerWelch( data )
%PWELCH returns welch power spectral density estmation
%   Takes data and returns welch power spectral density estimation

welch_value = pwelch(data,256,128,[],512);

end


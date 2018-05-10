function [ data_env ] = SignalEnveloppe( data, time_window )
%DATA_ENVELOPPE returns the enveloppe of the frequency power from the data
%   Computes window's average based
%   Size of window calculated from n% of the datasize 

B = 1/floor(time_window*ones(time_window,1));
data_env = filter(B,1,data);

end


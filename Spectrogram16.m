function [s, f, t, PSD] = Spectrogram16(data)
%Specrogram16 
%   yes

for i = 1:16
    [s(:,:,i), f(:,:,i), t(:,:,i), PSDtemp] = spectrogram(data(:,i), 512, 512-32, 4:2:48, 512, 'power', 'yaxis');
    PSD(:,:,i) = PSDtemp';
end


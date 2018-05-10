function [] = topoplot16( data, channel )
%TOPOPLOT16 plots 16 topoplots for each electrodes
%   Well well well

data_mean = mean(mean(data,3));

figure;
topoplot(data_mean', channel, 'style','both','electrodes','labelpoint');

end


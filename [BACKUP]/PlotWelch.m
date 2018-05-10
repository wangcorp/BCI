function [] = PlotWelch( welch3D )
%PLOTWELCH plots welch frequency power density
%   well well well

for i = 1:size(welch3D,3)
   figure;
   plot(10*log(welch3D(:,:,i)));
end

end


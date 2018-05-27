function [] = PlotWelch( welch3D )
%PLOTWELCH plots welch frequency power density
%   well well well

    for i = 1:size(welch3D,3)
       wel = 10*log(welch3D(:,:,i));
       mine = mean(wel,2);
       SD = std(wel,0,2);
       
      figure;
      shadedErrorBar([],mine, SD)
      xlabel('Frequency');
      ylabel('PSD');
       
    end

end


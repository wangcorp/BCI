function plotDistribution(PSD, labels, Features, FeatureNumber, FilteringMode)
%PlotDistribution 
%Function that plots histogram of the distribution of the data for the two
%classes for the feature passed in parameter

FreqDistr = 4:2:48;

histogram(log(PSD(labels==771,Features(1,FeatureNumber),Features(2,FeatureNumber))));
hold on;
histogram(log(PSD(labels==773,Features(1,FeatureNumber),Features(2,FeatureNumber))));
legend('Class 771','Class 773');
xlabel('Feature value');
ylabel('Frequency of the distribution')
title(['Channel ', num2str(Features(2,FeatureNumber)),' , frequency of ', num2str(FreqDistr(Features(1,FeatureNumber))), ' Hz (', FilteringMode, ' filtering)']);
hold off;

end


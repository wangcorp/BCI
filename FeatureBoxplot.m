function FeatureBoxplot(PSD, labels, Features, FeatureNb)

x = log(PSD(labels==773,Features(1,FeatureNb),Features(2,FeatureNb)));
y = log(PSD(labels==771,Features(1,FeatureNb),Features(2,FeatureNb)));
group = [ones(size(x)); 2*ones(size(y))];
boxplot([x;y], group, 'Notch', 'on');
set(gca,'XTickLabel',{'Class 773 (Hands)','Class 771 (Feet)'})
title('Boxplot of the feature values for both classes');
xlabel('Feature values'); ylabel('Feature distribution');

end


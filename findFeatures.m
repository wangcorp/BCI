function [BestFeatures] = findFeatures(PSD_,labels_,runs_labels, RunNb)
%findFeatures
%Function that computes the fisher score on the psd matrix, and
%determines the best 10 features (freq.-channel pairs) according to the
%Fisher score (highest Fisher score == biggest difference between the
%distribution for both classes)

% Cuts the data into the right trial
PSD = PSD_(runs_labels==RunNb,:,:);
labels = labels_(runs_labels==RunNb);

% Computation of the fisher score
FisherScore = zeros(23,16);
for i = 1:16 
    for j = 1:23
        FisherScore(j,i) = abs(mean(log(PSD(labels==771,j,i)))-mean(log(PSD(labels==773,j,i))))./sqrt(std(log(PSD(labels==771,j,i))).^2+std(log(PSD(labels==773,j,i))).^2);
    end
end
 
% Frequencies x channels heat map
figure();
imagesc(FisherScore')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title("Fisher Score for all couple channels/frequencies for run " + num2str(RunNb));

% Finds the indexes of the best 10 pair of channel-freq. according to
% Fisher score
BestFreqs = zeros(1,10);
BestChannels = zeros(1,10);

for i=1:10
    [A, I_col] = max(max(FisherScore)); %I_col == column == best channel
    [W, WI] = max(FisherScore);
    I_row = WI(I_col); %I_row == line == best freq
    FisherScore(I_row,I_col) = 0;
    BestFreqs(i) = I_row;
    BestChannels(i) = I_col;
end

BestFeatures = [BestFreqs; BestChannels]

end


function [ Fisher_sorted_Freq, Idx_sorted_Freq, Fisher_sorted_Chan, Idx_sorted_Chan ] = FisherScore( PSD,labels )
%FISHERSCORE calculates the fisher score between two labels

FisherScore = zeros(23,16);

for i = 1:16 
    for j = 1:23
        FisherScore(j,i) = abs(mean(log(PSD(labels==771,j,i)))-mean(log(PSD(labels==773,j,i))))/sqrt(std(log(PSD(labels==771,j,i)))+std(log(PSD(labels==773,j,i))));
    end
end

[Fisher_sorted_Freq, Idx_sorted_Freq] = sort(FisherScore,'descend'); % To sort frequencies
[Fisher_sorted_Chan, Idx_sorted_Chan] = sort(Fisher_sorted_Freq,2,'descend'); % To sort channels

end
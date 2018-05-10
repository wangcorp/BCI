%Initialization
addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material/biosig')); %to add the right library
addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\eeglab13_4_4b'));
load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\laplacian_16_10-20_mi.mat');
load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\channel_location_16_10-20_mi.mat');

[s, h] = sload('anonymous.20170613.161402.offline.mi.mi_bhbf.gdf');

EventId = 781;

StartPositions = h.EVENT.POS(h.EVENT.TYP==EventId);
MinDuration = min(event
StopPositions = StartPositions + MinDuration -1;

NumChannels = size(s, 2) - 1;
NumTrials = length(StartPositions);
Epoch = zeros(MinDuration, NumChannels, NumTrials); %duration different for trials (choose the min), NumChannels (known but remove hardware trigger channel), NumTrials (known)

for trId = 1:NumTrials
    cstart = StartPositions(trId);
    cstop = StopPositions(trId);
    disp(['Continuous feedback for trial ' num2str(trId) ' starts at ' num2str(cstart) ', stops at ' num2str(cstop) '.']);
    
    Epoch(:, :, trId) = s(cstart:cstop, 1:NumChannels);
end

Triallb = h.EVENT.TYP(h.EVENT.TYP == 771 | h.EVENT.TYP == 773);

AverageClass1 = mean(Epoch(:, 9,Triallb == 771),3);
AverageClass2 = mean(Epoch(:, 9,Triallb == 773),3);

figure;
subplot(1,2,1);
plot(AverageClass1);
title('Channel 9, Class 771');
xlabel('samples');
ylabel('uV');
subplot(1,2,2);
plot(AverageClass2);
title('Channel 9, Class 773');
xlabel('samples');
ylabel('uV');

[b, a] = butter(2, ([8,12]*2)/512);
data = Epoch(:,9,1);
data_filtered = filter(b,a,data);

figure;
hold on;
plot(data);
plot(data_filtered);
hold off;
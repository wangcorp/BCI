%Initialization
close all;
%clear all;

% %RUIJIA
addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\biosig')); %to add the right library
addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\eeglab13_4_4b'));
load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\laplacian_16_10-20_mi.mat');
load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\channel_location_16_10-20_mi.mat');

% %SEB
% addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/biosig'));
% addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Projects - Common material-20180301/eeglab13_4_4b'));
% load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/laplacian_16_10-20_mi.mat');
% load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/channel_location_16_10-20_mi.mat');

% % Emilie
% addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/biosig'));
% addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/eeglab13_4_4b'));
% load('/Users/emilierevol/Desktop/BCI/Projects - Common material/laplacian_16_10-20_mi.mat');
% load('/Users/emilierevol/Desktop/BCI/Projects - Common material/channel_location_16_10-20_mi.mat');


%% load PSD files
[filename] = ImportFiles();
load(filename);

%% Parameters
FreqGrid = 4:2:48;
RandomBands = 14:40;
[~, RandomBandsId] = intersect(FreqGrid, RandomBands);

%% Epoch
PSD_car_hands = PSD_car(labels_car==773,:,:);
PSD_lap_hands = PSD_lap(labels_lap==773,:,:);
log_PSD_car_hands = log(PSD_car_hands+1);
log_PSD_lap_hands = log(PSD_lap_hands+1);

PSD_car_feet = PSD_car(labels_car==771,:,:);
PSD_lap_feet = PSD_lap(labels_lap==771,:,:);
log_PSD_car_feet = log(PSD_car_feet+1);
log_PSD_lap_feet = log(PSD_lap_feet+1);

PSD_car_baseline = PSD_car(labels_car==786,:,:);
PSD_lap_baseline = PSD_lap(labels_lap==786,:,:);
log_PSD_car_baseline = log(PSD_car_baseline+1);
log_PSD_lap_baseline = log(PSD_lap_baseline+1);

%% ERD/ERS
ERD_ERS_car_hands = 100*squeeze((mean(log_PSD_car_hands) - mean(log_PSD_car_baseline))./(mean(log_PSD_car_baseline)+mean(log_PSD_car_hands)));
ERD_ERS_lap_hands = 100*squeeze((mean(log_PSD_lap_hands) - mean(log_PSD_lap_baseline))./(mean(log_PSD_lap_baseline)+mean(log_PSD_lap_hands)));

ERD_ERS_car_feet = 100*squeeze((mean(log_PSD_car_feet) - mean(log_PSD_car_baseline))./(mean(log_PSD_car_baseline)+mean(log_PSD_car_feet)));
ERD_ERS_lap_feet = 100*squeeze((mean(log_PSD_lap_feet) - mean(log_PSD_lap_baseline))./(mean(log_PSD_lap_baseline)+mean(log_PSD_lap_feet)));

%% Topoplot
figure('Name','car hands');
title('ERD/ERS hands - car');
topo_car_hands = squeeze(mean(ERD_ERS_car_hands(RandomBandsId,:)));
topoplot(topo_car_hands, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
axis('auto');

figure('Name','lap hands');
title('ERD/ERS hands - laplacian');
topo_lap_hands = squeeze(mean(ERD_ERS_lap_hands(RandomBandsId,:)));
topoplot(topo_lap_hands, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
axis('auto');

figure('Name','car feet');
title('ERD/ERS feet - car');
topo_car_feet = squeeze(mean(ERD_ERS_car_feet(RandomBandsId,:)));
topoplot(topo_car_feet, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
axis('auto');

figure('Name','lap feet');
title('ERD/ERS feet - laplacian');
topo_lap_feet = squeeze(mean(ERD_ERS_lap_feet(RandomBandsId,:)));
topoplot(topo_lap_feet, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
axis('auto');

%% Fisher score
%car
[Fisher_car_sorted_Freq, Idx_car_sorted_Freq, Fisher_car_sorted_Chan, Idx_car_sorted_Chan] = FisherScore(PSD_car, labels_car);

BestFreqs_car = Idx_car_sorted_Freq(1:10,1); % The best frequency for the first 10 channels with highest Fisher Score
BestChannels_car = Idx_car_sorted_Chan(1,1:10); % The best channels for the first 10 frequencies with highest Fisher Score

figure();
histogram(log(PSD_car(labels_car==771,BestFreqs_car(1),BestChannels_car(1))));
hold on;
histogram(log(PSD_car(labels_car==773,BestFreqs_car(1),BestChannels_car(1))));
legend('Class 771','Class 773');
xlabel('Feature value');
ylabel('Frequency of the distribution')
title(['Feature with the higher Fisher Score - Channel', num2str(BestChannels_car(1)) ,', frequency of ', num2str(BestFreqs_car(1)),'Hz (Using CAR filtering)']);

%lap
[Fisher_lap_sorted_Freq, Idx_lap_sorted_Freq, Fisher_lap_sorted_Chan, Idx_lap_sorted_Chan] = FisherScore(PSD_lap, labels_lap);

BestFreqs_lap = Idx_lap_sorted_Freq(1:10,1); % The best frequency for the first 10 channels with highest Fisher Score
BestChannels_lap = Idx_lap_sorted_Chan(1,1:10); % The best channels for the first 10 frequencies with highest Fisher Score

figure();
histogram(log(PSD_lap(labels_lap==771,BestFreqs_lap(1),BestChannels_lap(1))));
hold on;
histogram(log(PSD_lap(labels_lap==773,BestFreqs_lap(1),BestChannels_lap(1))));
legend('Class 771','Class 773');
xlabel('Feature value');
ylabel('Frequency of the distribution')
title(['Feature with the higher Fisher Score - Channel', num2str(BestChannels_lap(1)) ,', frequency of ', num2str(BestFreqs_lap(1)),'Hz (Using LAP filtering)']);
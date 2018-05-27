%Initialization
close all;
%clear all;

% %RUIJIA
% addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\biosig')); %to add the right library
% addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\eeglab13_4_4b'));
% load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\laplacian_16_10-20_mi.mat');
% load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\channel_location_16_10-20_mi.mat');

%SEB
addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/biosig'));
addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Projects - Common material-20180301/eeglab13_4_4b'));
load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/laplacian_16_10-20_mi.mat');
load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/channel_location_16_10-20_mi.mat');

% % % Emilie
% addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/biosig'));
% addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/eeglab13_4_4b'));
% load('/Users/emilierevol/Desktop/BCI/Projects - Common material/laplacian_16_10-20_mi.mat');
% load('/Users/emilierevol/Desktop/BCI/Projects - Common material/channel_location_16_10-20_mi.mat');


%% load PSD files
[filename] = ImportFiles();
load(filename);

%% Parameters
FreqGrid = 4:2:48;
RandomBands = 8:20;
[~, RandomBandsId] = intersect(FreqGrid, RandomBands);


%% Epoching
PSD_car_hands = PSD_car(labels_car==773,:,:);
PSD_lap_hands = PSD_lap(labels_lap==773,:,:);
PSD_nofilter_hands = PSD_nofilter(labels_lap==773,:,:);
log_PSD_car_hands = log(PSD_car_hands+1);
log_PSD_lap_hands = log(PSD_lap_hands+1);
log_PSD_nofilter_hands = log(PSD_nofilter_hands+1);

PSD_car_feet = PSD_car(labels_car==771,:,:);
PSD_lap_feet = PSD_lap(labels_lap==771,:,:);
PSD_nofilter_feet = PSD_nofilter(labels_lap==771,:,:);
log_PSD_car_feet = log(PSD_car_feet+1);
log_PSD_lap_feet = log(PSD_lap_feet+1);
log_PSD_nofilter_feet = log(PSD_nofilter_feet+1);

PSD_car_baseline = PSD_car(labels_car==786,:,:);
PSD_lap_baseline = PSD_lap(labels_lap==786,:,:);
PSD_nofilter_baseline = PSD_nofilter(labels_lap==786,:,:);
log_PSD_car_baseline = log(PSD_car_baseline+1);
log_PSD_lap_baseline = log(PSD_lap_baseline+1);
log_PSD_nofilter_baseline = log(PSD_nofilter_baseline+1);

%% ERD/ERS
ERD_ERS_car_hands = 100*squeeze((mean(log_PSD_car_hands) - mean(log_PSD_car_baseline))./(mean(log_PSD_car_baseline)+mean(log_PSD_car_hands)));
ERD_ERS_lap_hands = 100*squeeze((mean(log_PSD_lap_hands) - mean(log_PSD_lap_baseline))./(mean(log_PSD_lap_baseline)+mean(log_PSD_lap_hands)));
ERD_ERS_nofilter_hands = 100*squeeze((mean(log_PSD_nofilter_hands) - mean(log_PSD_nofilter_baseline))./(mean(log_PSD_nofilter_baseline)+mean(log_PSD_nofilter_hands)));

ERD_ERS_car_feet = 100*squeeze((mean(log_PSD_car_feet) - mean(log_PSD_car_baseline))./(mean(log_PSD_car_baseline)+mean(log_PSD_car_feet)));
ERD_ERS_lap_feet = 100*squeeze((mean(log_PSD_lap_feet) - mean(log_PSD_lap_baseline))./(mean(log_PSD_lap_baseline)+mean(log_PSD_lap_feet)));
ERD_ERS_nofilter_feet = 100*squeeze((mean(log_PSD_nofilter_feet) - mean(log_PSD_nofilter_baseline))./(mean(log_PSD_nofilter_baseline)+mean(log_PSD_nofilter_feet)));

%% Topoplot
figure();
subplot(2,3,1)
title('ERD/ERS "Both hands" - CAR filtering');
topo_car_hands = squeeze(mean(ERD_ERS_car_hands(RandomBandsId,:)));
topoplot(topo_car_hands, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
caxis([-15 15]);

subplot(2,3,2);
title('ERD/ERS "Both hands" - Laplacian filtering');
topo_lap_hands = squeeze(mean(ERD_ERS_lap_hands(RandomBandsId,:)));
topoplot(topo_lap_hands, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
caxis([-15 15]);

subplot(2,3,4)
title('ERD/ERS "Both feet" - CAR filtering');
topo_car_feet = squeeze(mean(ERD_ERS_car_feet(RandomBandsId,:)));
topoplot(topo_car_feet, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
caxis([-15 15]);

subplot(2,3,5)
title('ERD/ERS "Both feet" - Laplacian filtering');
topo_lap_feet = squeeze(mean(ERD_ERS_lap_feet(RandomBandsId,:)));
topoplot(topo_lap_feet, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
caxis([-15 15]);

subplot(2,3,3)
title('ERD/ERS "Both hands" - No filter');
topo_nofilter_hands = squeeze(mean(ERD_ERS_nofilter_hands(RandomBandsId,:)));
topoplot(topo_nofilter_hands, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
caxis([-15 15]);

subplot(2,3,6)
title('ERD/ERS "Both feet" - No filter');
topo_nofilter_feet = squeeze(mean(ERD_ERS_nofilter_feet(RandomBandsId,:)));
topoplot(topo_nofilter_feet, chanlocs16, 'style','both','electrodes','labelpoint');
colorbar;
caxis([-15 15]);

%% Discriminancy
% Visually check and select features that are stable across runs!
 
% CAR
%Run 1
f = figure;
p = uipanel('Parent',f,'BorderType','none'); 
p.Title = 'Fisher Score for all couple channels/frequencies'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';
subplot(2,3,1,'Parent',p)
[Features_car_run1, FisherScoreC1] = findFeatures(PSD_car, labels_car, labels_runs, 1);
imagesc(FisherScoreC1')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title(" Run 1 - CAR");

%Run 2
subplot(2,3,2,'Parent',p)
[Features_car_run2, FisherScoreC2] = findFeatures(PSD_car, labels_car, labels_runs, 2);
imagesc(FisherScoreC2')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title("Run 2 - CAR");


%Run 3
subplot(2,3,3,'Parent',p)
[Features_car_run3, FisherScoreC3] = findFeatures(PSD_car, labels_car, labels_runs, 3);
imagesc(FisherScoreC3')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title("Run 3 - CAR");


% LAPLACIAN
%Run 1
subplot(2,3,4,'Parent',p)
[Features_lap_run1, FisherScoreL1] = findFeatures(PSD_lap, labels_lap, labels_runs, 1);
imagesc(FisherScoreL1')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title("Run 1 - LAP");

%Run 2
subplot(2,3,5,'Parent',p)
[Features_lap_run2, FisherScoreL2] = findFeatures(PSD_lap, labels_lap, labels_runs, 2);
imagesc(FisherScoreL2')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title("Run 2 - LAP");

%Run 3
subplot(2,3,6,'Parent',p)
[Features_lap_run3, FisherScoreL3] = findFeatures(PSD_lap, labels_lap, labels_runs, 3);
imagesc(FisherScoreL3')
colorbar
ylabel('Channels')
xlabel('Frequencies')
title("Run 3 - LAP");

%Distributions
%CAR
plotDistribution(PSD_car(labels_runs==1,:,:), labels_car(labels_runs==1), Features_car_run1, 1, 'CAR');
plotDistribution(PSD_car(labels_runs==2,:,:), labels_car(labels_runs==2), Features_car_run2, 1, 'CAR');
plotDistribution(PSD_car(labels_runs==3,:,:), labels_car(labels_runs==3), Features_car_run3, 1, 'CAR');

%LAP
plotDistribution(PSD_lap(labels_runs==1,:,:), labels_lap(labels_runs==1), Features_lap_run1, 1, 'Laplacian');
plotDistribution(PSD_lap(labels_runs==2,:,:), labels_lap(labels_runs==2), Features_lap_run2, 1, 'Laplacian');
plotDistribution(PSD_lap(labels_runs==3,:,:), labels_lap(labels_runs==3), Features_lap_run3, 1, 'Laplacian');




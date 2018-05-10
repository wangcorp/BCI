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

%% Import
[filename] = ImportFiles();
[s1, h1] = sload(filename{1});
[s2, h2] = sload(filename{2});
[s3, h3] = sload(filename{3});

%% Filtering
%[data_filtered_1] = FilterFreq(data);
[data_car_1] = FilterCar(s1(:,1:16));
[data_car_2] = FilterCar(s2(:,1:16));
[data_car_3] = FilterCar(s3(:,1:16));

[data_lap_1] = FilterSmallLap(s1(:,1:16),lap);
[data_lap_2] = FilterSmallLap(s2(:,1:16),lap);
[data_lap_3] = FilterSmallLap(s3(:,1:16),lap);

%% PSD
[~, f_car_1, t_car_1, PSD_car_1] = Spectrogram16(data_car_1);
[~, f_car_2, t_car_2, PSD_car_2] = Spectrogram16(data_car_2);
[~, f_car_3, t_car_3, PSD_car_3] = Spectrogram16(data_car_3);

[~, f_lap_1, t_lap_1, PSD_lap_1] = Spectrogram16(data_lap_1);
[~, f_lap_2, t_lap_2, PSD_lap_2] = Spectrogram16(data_lap_2);
[~, f_lap_3, t_lap_3, PSD_lap_3] = Spectrogram16(data_lap_3);

%% Down sampling
h1.EVENT.POS = floor(h1.EVENT.POS/32);
h1.EVENT.DUR = floor(h1.EVENT.DUR/32);

h2.EVENT.POS = floor(h2.EVENT.POS/32);
h2.EVENT.DUR = floor(h2.EVENT.DUR/32);

h3.EVENT.POS = floor(h3.EVENT.POS/32);
h3.EVENT.DUR = floor(h3.EVENT.DUR/32);

%% Concatenate
[PSD_car, event_car] = ConcatenatePSD(PSD_car_1, PSD_car_2, PSD_car_3, h1, h2, h3);
[PSD_lap, event_lap] = ConcatenatePSD(PSD_lap_1, PSD_lap_2, PSD_lap_3, h1, h2, h3);

[labels_car] = MakeLabels(PSD_car, event_car);
[labels_lap] = MakeLabels(PSD_lap, event_lap);

%% Save PSD
save('PSD.mat', 'PSD_car', 'PSD_lap', 'labels_car', 'labels_lap');
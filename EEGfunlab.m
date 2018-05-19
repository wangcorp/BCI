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

%773=pieds(colonne 1)
%771=mains(colonne 2)

%% Best Features selection and extraction
sel_chan = [7,8,9,10,9]; %to fill according to previous feat selection
sel_freq = [5,5,11,5,10]; %to fill according to previous feat selection

for i=1:length(sel_chan);
    if i==1
        PSD_feat_car=PSD_car((labels_car==771 | labels_car==773), sel_freq(1), sel_chan(1));
    end
    PSD_feat_car=[PSD_feat_car,  PSD_car((labels_car==771 | labels_car==773), sel_freq(i), sel_chan(i))];
end

%PSD_feat_car = [PSD_car((labels_car==771 | labels_car==773), sel_freq(1), sel_chan(1)) , PSD_car((labels_car==771 | labels_car==773), sel_freq(2), sel_chan(2))];
labels_feat = labels_car(labels_car==771 | labels_car==773);

%% Training
classifier = fitcdiscr(PSD_feat_car, labels_feat);
[yhat, score] = predict(classifier, PSD_feat_car);

%% Online processing
main;
for i=1:length(sel_chan);
    if i==1
        PSD_feat_car_online = PSD_car(:, sel_freq(1), sel_chan(1));
    end
    PSD_feat_car_online=[PSD_feat_car_online,  PSD_car(:, sel_freq(i), sel_chan(i))];
end

%% Classifier test
alpha=0.5;
dt_total = [];

event_trial = find(event_car(:,1)==771 | event_car(:,1)==773);
decision = zeros(1,length(event_trial));

for trialID = 1:length(event_trial)
    dt=0.5;
    for windowID = 2:floor((event_car(event_trial(trialID),3)+event_car(event_trial(trialID)+1,3))/32)
        [yhat_online,score_online] = predict(classifier,PSD_feat_car_online(event_car(event_trial(trialID),2)+(windowID-1)*32:(event_car(event_trial(trialID),2)+(windowID-1)*32)+32,:));
        ppt = mean(score_online(:,1));
        dt=[dt,ppt*alpha + dt(:,windowID-1)*(1-alpha)];
    end
    %dt_total{end+1,:} =  dt;
    if dt(end) >= 0.6
        decision(trialID)=1;
    elseif dt(end) <=0.3
        decision(trialID)=-1;
    end
end
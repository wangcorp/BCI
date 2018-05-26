%% Initialization
close all;
%clear all;

% %RUIJIA
% addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\biosig')); %to add the right library
% addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\eeglab13_4_4b'));
% load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\laplacian_16_10-20_mi.mat');
% load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\channel_location_16_10-20_mi.mat');

% %SEB
% addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/biosig'));
% addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Projects - Common material-20180301/eeglab13_4_4b'));
% load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/laplacian_16_10-20_mi.mat');
% load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/channel_location_16_10-20_mi.mat');

% % Emilie
addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/biosig'));
addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/eeglab13_4_4b'));
load('/Users/emilierevol/Desktop/BCI/Projects - Common material/laplacian_16_10-20_mi.mat');
load('/Users/emilierevol/Desktop/BCI/Projects - Common material/channel_location_16_10-20_mi.mat');

%% INFO
% 303 = both feet = 771 = -1 = colum 1 of score_online;
% 305 = both hands = 773 = 1 = column 2 of score_online;

%% load PSD files
[filename] = ImportFiles();
load(filename);

%% Best Features selection and training data formating
sel_freq = [6,6,6,6,6,6,5]; %to fill according to the selected best features (frequencies)
sel_chan = [16,12,11,7,15,8,12]; %to fill according to the selected best features (channels)

for i=1:length(sel_chan)
    if i==1
        PSD_feat_car=PSD_car((labels_car==771 | labels_car==773), sel_freq(1), sel_chan(1));
    end
    PSD_feat_car=[PSD_feat_car,  PSD_car((labels_car==771 | labels_car==773), sel_freq(i), sel_chan(i))];
end

labels_feat = labels_car(labels_car==771 | labels_car==773);

%% Training
classifier = fitcdiscr(PSD_feat_car, labels_feat);
[yhat, score] = predict(classifier, PSD_feat_car);

%% Test data formating
% Using features selected from training data
main;
for i=1:length(sel_chan);
    if i==1
        PSD_feat_car_online = PSD_car(:, sel_freq(1), sel_chan(1));
    end
    PSD_feat_car_online=[PSD_feat_car_online,  PSD_car(:, sel_freq(i), sel_chan(i))];
end

%% Classifier (testing)
alpha=0.3;
dt_total = [];

event_trial = find(event_car(:,1)==771 | event_car(:,1)==773);
decision = zeros(1,length(event_trial));

decision_true = ones(1,length(event_trial));
for i=1:length(event_trial)
   if event_car(event_trial(i),1)==771
       decision_true(i) = -1;
   end
end

dt_memory = {};

for trialID = 1:length(event_trial)
    dt=0.5;
    for windowID = 2:event_car(event_trial(trialID),3)+event_car(event_trial(trialID)+1,3)
        [yhat_online,score_online] = predict(classifier,PSD_feat_car_online(event_car(event_trial(trialID),2)+windowID-1,:));
        ppt = score_online(:,2); % Column 1: feet (773), column 2: hands (771)
        dt=[dt,ppt*alpha + dt(:,windowID-1)*(1-alpha)];
        %dt_total{end+1,:} =  dt;
        if dt(windowID) >= 0.7
            decision(trialID)=1; % hands
            break
        elseif dt(windowID) <=0.3
            decision(trialID)=-1; % feet
            break
        end
    end
    dt_memory(end+1,:) = {dt};
end

%% Classifier performance evaluation

classification_error = classerror(decision_true, decision); %% Classification error = sum(decision~=decision_true)./length(decision_true);
class_error = (1/2)*sum((decision_true==1)~=(decision==1))./sum(decision_true==1) + (1/2)*sum((decision_true==-1)~=(decision==-1))./sum(decision_true==-1);

C = confusionmat(decision, decision_true);
C(1,:) = C(1,:) ./ sum(C(1,:));
C(2,:) = C(2,:) ./ sum(C(2,:));

figure();
imagesc(C);
xticklabels({'', 'Class 1 (Feet)', '', 'Class -1 (Hands)'}); 
yticklabels({'', 'Class 1 (Feet)', '', 'Class -1 (Hands)'}); 
colorbar; xlabel('Decoded classes'); ylabel('True classes');
title('Confusion matrix of the decoder');
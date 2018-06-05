%% Initialization
close all;
%clear all;

tic;

% %RUIJIA - cartop
% addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\biosig')); %to add the right library
% addpath(genpath('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\eeglab13_4_4b'));
% load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\carlacian_16_10-20_mi.mat');
% load('C:\Users\Ruijia\Documents\EPFL\BCI\Project - Commmon material\channel_location_16_10-20_mi.mat');

% RUIJIA - home
addpath(genpath('C:\Users\Waz\Documents\EPFL\BCI\Common\biosig'));
addpath(genpath('C:\Users\Waz\Documents\EPFL\BCI\Common\eeglab13_4_4b'));
load('C:\Users\Waz\Documents\EPFL\BCI\Common\laplacian_16_10-20_mi.mat');
load('C:\Users\Waz\Documents\EPFL\BCI\Common\channel_location_16_10-20_mi.mat');

% %SEB
% addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/biosig'));
% addpath(genpath('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Projects - Common material-20180301/eeglab13_4_4b'));
% load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/carlacian_16_10-20_mi.mat');
% load('/Users/sebh/Dropbox/EPFL2/EPFL/1MASTER/Semestre2/BCI/Project/ai6_micontinuous/20180316/channel_location_16_10-20_mi.mat');

% % Emilie
% addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/biosig'));
% addpath(genpath('/Users/emilierevol/Desktop/BCI/Project 2 - Naturally controlling a MI BCI-driven robot/project2-data-example/eeglab13_4_4b'));
% load('/Users/emilierevol/Desktop/BCI/Projects - Common material/carlacian_16_10-20_mi.mat');
% load('/Users/emilierevol/Desktop/BCI/Projects - Common material/channel_location_16_10-20_mi.mat');

%% INFO
% 303 = both feet = 771 = -1 = colum 1 of score_online;
% 305 = both hands = 773 = 1 = column 2 of score_online;

%% load PSD files
[filename] = ImportFiles();
load(filename);

%% Best Features selection and training data formating
% Seb
% sel_freq = [8,9,10]; %to fill according to the selected best features (frequencies)
% sel_chan = [9,9,9]; %to fill according to the selected best features (channels)

% Ruijia
% sel_freq = [6,6,11]; %to fill according to the selected best features (frequencies)
% sel_chan = [7,11,9]; %to fill according to the selected best features (channels)

% Emilie
sel_freq = [6,6,6,6]; %to fill according to the selected best features (frequencies)
sel_chan = [11,16,7,12]; %to fill according to the selected best features (channels)



for i=1:length(sel_chan)
    if i==1
        PSD_feat_car=PSD_car((labels_car==771 | labels_car==773), sel_freq(1), sel_chan(1));
    end
    PSD_feat_car=[PSD_feat_car,  PSD_car((labels_car==771 | labels_car==773), sel_freq(i), sel_chan(i))];
end
PSD_feat_car = log(PSD_feat_car);
labels_feat = labels_car(labels_car==771 | labels_car==773);

%% Training
classifier = fitcdiscr(PSD_feat_car, labels_feat);
%[yhat, score] = predict(classifier, PSD_feat_car);

%% Test data formating
% Using features selected from training data
DataPreprocessing;
for i=1:length(sel_chan)
    if i==1
        PSD_feat_car_online = PSD_car(:, sel_freq(1), sel_chan(1));
    end
    PSD_feat_car_online=[PSD_feat_car_online,  PSD_car(:, sel_freq(i), sel_chan(i))];
end
PSD_feat_car_online = log(PSD_feat_car_online);

%% Classifier (testing)
%Tweakable variables
alpha=0.89;
trial_continuous = true;
y_down = 0.3;
y_up = 0.7;

%ROC VARIABLES:
FPR = [];
TPR = [];
AUC = [];
sco_on = [];

dt_total = [];

event_trial = find(event_car(:,1)==771 | event_car(:,1)==773);
decision = zeros(1,length(event_trial));
decision_time = zeros(1,length(event_trial));

decision_true = ones(1,length(event_trial));
for i=1:length(event_trial)
    if event_car(event_trial(i),1)==771
        decision_true(i) = -1;
    end
end

switch trial_continuous
    case false
        dt_memory = {};
        for trialID = 1:length(event_trial)
            dt=0.5;
            for windowID = 2:event_car(event_trial(trialID),3)+event_car(event_trial(trialID)+1,3)
                [yhat_online,score_online] = predict(classifier,PSD_feat_car_online(event_car(event_trial(trialID),2)+windowID-1,:));
                ppt = score_online(:,2); % Column 1: feet (773), column 2: hands (771)
                dt=[dt,ppt*(1-alpha) + dt(:,windowID-1)*alpha];
                sco_on = [sco_on; score_online]; %For the ROC

                if dt(windowID) >= y_up
                    decision(trialID)=1; % hands
                    break
                elseif dt(windowID) <= y_down
                    decision(trialID)=-1; % feet
                    break
                end
            end
            dt_memory(end+1,:) = {dt};
        end
        
    case true
        dt_memory = zeros(1,length(PSD_feat_car_online)-1);
        dt_memory = [0.5, dt_memory];
        
        trial_counter = 0;
        trial_time = 0;
        trial_check = false;
        current_trial = 2;
        dt_old = 0.5;
        
        for windowID = 2:length(PSD_feat_car_online)
            [yhat,score_online]=predict(classifier,PSD_feat_car_online(windowID,:));
            ppt = score_online(:,2);
            trial_start = (windowID == event_car(event_trial,2));
            trial_start_sort = sort(trial_start);
            
            sco_on = [sco_on; score_online]; %For the ROC

            if trial_start_sort(end)==1
                current_trial=find(trial_start==1);
                trial_counter = trial_counter+1;
                trial_check = true;
                trial_time = 0;
                dt=0.5;
                dt_old = dt;
            else
                dt=ppt*(1-alpha) + dt_old*alpha;
                dt_old = dt;
            end
            
            if windowID == event_car(current_trial,2)+event_car(current_trial,3)+event_car(current_trial+1,3)
                trial_check=false;
            end
            
            if trial_check == true
                trial_time = trial_time+1;
                if dt >= y_up
                    decision(trial_counter)=1; % hands
                    decision_time(trial_counter)=trial_time;%-event_car(event_trial(current_trial),2);
                    trial_check = false;
                elseif dt <= y_down
                    decision(trial_counter)=-1; % feet
                    decision_time(trial_counter)=trial_time;
                    trial_check = false;
                end
            end

            dt_memory(windowID)=dt;
            
        end
end

%% ROC VALUES and plotting:
labels_car = labels_car(2:end); %Starting from window 2                                    
[FPR, TPR, ~, AUC] = perfcurve(labels_car(labels_car==771 | labels_car==773), sco_on((labels_car==771 | labels_car==773),2), 773);
x = linspace(0,1,10);
y = linspace(0,1,10);
plot(FPR,TPR,'-r')
hold on
plot(x,y,'--b')
xlabel('False positive rate') 
ylabel('True positive rate')
te = ['Mean AUC: ', num2str(mean(AUC))];
title('ROC curve')
text(0.6,0.2,te);

%% Plot Task classifier
if trial_continuous == true
    figure;
    hold on
    for i=1:length(event_trial)
        if event_car(event_trial(i),1) == 771
            rectangle('Position', [event_car(event_trial(i),2) 0 event_car(event_trial(i),3)+event_car(event_trial(i)+1,3) 1], 'FaceColor', [0 0 1 0.2],'LineStyle','none');
        else
            rectangle('Position', [event_car(event_trial(i),2) 0 event_car(event_trial(i),3)+event_car(event_trial(i)+1,3) 1], 'FaceColor', [1 0 0 0.2],'LineStyle','none');
        end
    end
    
    plot(dt_memory, 'Color', 'k');
    line([0,length(PSD_feat_car_online)],[y_down,y_down], 'Color', 'k');
    line([0,length(PSD_feat_car_online)],[y_up,y_up], 'Color', 'k');
    xlim([0 5000]);
    title('Decision probability as a function of time window and task');
    xlabel('time window [-]');
    ylabel('Decision probability [-]');
    hold off
end

%% Classifier performance evaluation
%time estimation
decision_time_mean = (mean(decision_time(decision_time~=0))*32)/512;
decision_time_std = (std(decision_time)*32)/512;
%error estimation
miss_class = 0;
for i=1:length(decision_true)
    if decision_true(i) ~= decision(i)
        miss_class = miss_class + 1;
    end
end
classification_error = miss_class/length(decision_true);
class_error = classerror(decision_true, decision); 

if ismember(0,decision)==1
    C = confusionmat(decision, decision_true);
    C(:,1) = C(:,1) ./ sum(C(:,1));
    C(:,3) = C(:,3) ./ sum(C(:,3));
    
    figure();
    imagesc(C);
    xticklabels({'', 'Class 773 (Hands)','', 'No decision','', 'Class 771 (Feet)'}); 
    yticklabels({'','Class 773 (Hands)','', 'No decision','', 'Class 771 (Feet)'}); 
    colorbar; xlabel('True classes','FontWeight','bold'); ylabel('Decoded classes','FontWeight','bold');
    title('Confusion matrix of the decoder');
else 
    C = confusionmat(decision, decision_true);
    C(:,1) = C(:,1) ./ sum(C(:,1));
    C(:,2) = C(:,2) ./ sum(C(:,2));

    figure();
    imagesc(C);
    xticklabels({'', 'Class 773 (Hands)','', 'Class 771 (Feet)'}); 
    yticklabels({'','Class 773 (Hands)','', 'Class 771 (Feet)'}); 
    colorbar; xlabel('True classes'); ylabel('Decoded classes');
    title('Confusion matrix of the decoder');
end

%% Structure creation
support.model = classifier;
support.alpha = alpha;
support.lap = lap;
support.feat = [sel_freq;sel_chan];
support.car = false;
save('support.mat', 'support');

toc;
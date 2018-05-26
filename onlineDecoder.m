function [ decision_out,raw_probs ] = onlineDecoder( EEGw, decision_in, support )
%OnlineDecoder
%   decision_out = new decision
%   dcision_in = previous decision

% Filtering
if support.car == true
   EEGw_mean = mean(EEGw(:,1:16),2);
   EEGw = EEGw(:,1:16) - repmat(EEGw_mean,1,16); 
end
EEGw = EEGw(:,1:16)*(support.lap);

%PSD
for i = 1:16
    [~, ~, ~, PSDtemp] = spectrogram(EEGw(:,i), 512, 512-32, 4:2:48, 512, 'power', 'yaxis');
    PSD(:,:,i) = PSDtemp';
end

% Features extraction
% feat(1,:) - frequencies
% feat(2,:) - channels
for i=1:size(support.feat,2);
    if i==1
        PSD_feat=PSD(:, support.feat(1,1), support.feat(2,1));
    end
    PSD_feat=[PSD_feat, PSD(:, support.feat(1,i), support.feat(2,i))];
end
PSD_feat=log(PSD_feat);

% classifier
[~,raw_probs] = predict(support.model, PSD_feat);
decision_out = (raw_probs*support.alpha + decision_in*(1-support.alpha))';
raw_probs = raw_probs';
 
end


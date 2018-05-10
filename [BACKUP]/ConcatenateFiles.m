function [data, event] = ConcatenateFiles(h1,h2,h3,s1,s2,s3)
%CONCATENATOR Concatenated multiple files
%   Merge multiple eeg recording with event code, duration, and label

% [s1, h1] = sload(filename{1});
% [s2, h2] = sload(filename{2});
% [s3, h3] = sload(filename{3});

labels_files = [ones(1, length(s1)), 2*ones(1, length(s2)), 3*ones(1, length(s3))]';
size(labels_files)
s = [s1;s2;s3];
size(s)
data = [s labels_files];

type = [h1.EVENT.TYP;h2.EVENT.TYP;h3.EVENT.TYP];
MinDuration = (min(h1.EVENT.DUR));
StartPositions = [h1.EVENT.POS;h2.EVENT.POS+h1.EVENT.POS(end);h3.EVENT.POS+h1.EVENT.POS(end)+h2.EVENT.POS(end)];


labels_event = [ones(1, length(h1.EVENT.TYP)), 2*ones(1, length(h2.EVENT.TYP)), 3*ones(1, length(h3.EVENT.TYP))]';
event = [type (ones(length(type), 1)*MinDuration) StartPositions labels_event];

end


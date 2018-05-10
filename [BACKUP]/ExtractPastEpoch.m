function [ Epoch ] = ExtractPastEpoch( data, event, EventId )
%EXTRACTPASTEPOCH extracts epoch of Id1 before Id2
%   well well well

EventCoordinates = event(:,1)==EventId;
PastCoodinates = [EventCoordinates(2:end); false];

PastStartPositions = event(PastCoodinates, 3);
PastMinDuration = min(event(PastCoodinates, 2));
PastStopPositions = PastStartPositions + PastMinDuration -1;

NumChannels = size(data,2);
NumTrials = length(PastStartPositions);

Epoch = zeros(PastMinDuration, NumChannels, NumTrials);

for trId = 1:NumTrials
    cstart = PastStartPositions(trId);
    cstop = PastStopPositions(trId);
    Epoch(:, :, trId) = data(cstart:cstop, 1:NumChannels);
end

end


function [ Epoch ] = ExtractEpoch( data,event, EventId )
%extractEpoch takes data during cue and feedback
%  well well well

StartPositions = event(event(:,1)==EventId,3);
MinDuration = min(event(event(:,1)==EventId,2));
StopPositions = StartPositions + MinDuration - 1;

NumChannels = size(data,2);
NumTrials = length(StartPositions);
Epoch = zeros(MinDuration, NumChannels, NumTrials);

for trId = 1:NumTrials
    cstart = StartPositions(trId);
    cstop = StopPositions(trId);
    Epoch(:, :, trId) = data(cstart:cstop, 1:NumChannels);
end

end


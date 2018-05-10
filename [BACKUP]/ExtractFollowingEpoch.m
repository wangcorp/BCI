function [ Epoch ] = ExtractFollowingEpoch( data, event, EventId)
%ExtractFollowingEpoch extracts epoch of Id2 after Id1
%   well well well

EventCoordinates = event(:,1)==EventId;
FollowCoodinates = [false; EventCoordinates(1:(end-1))];

FollowStartPositions = event(FollowCoodinates, 3);
FollowMinDuration = min(event(FollowCoodinates, 2));
FollowStopPositions = FollowStartPositions + FollowMinDuration -1;

NumChannels = size(data,2);
NumTrials = length(FollowStartPositions);

Epoch = zeros(FollowMinDuration, NumChannels, NumTrials);

for trId = 1:NumTrials
    cstart = FollowStartPositions(trId);
    cstop = FollowStopPositions(trId);
    Epoch(:, :, trId) = data(cstart:cstop, 1:NumChannels);
end

end


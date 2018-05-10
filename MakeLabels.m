function [ label ] = MakeLabels( data, event )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
label = zeros(length(data),1);

for i = 1:length(event)
    if event(i,1)==771
        label(event(i,2):(event(i,2)+event(i,3)+event(i+1,3)),1)=771;
    elseif event(i,1)==773
        label(event(i,2):(event(i,2)+event(i,3)+event(i+1,3)),1)=773;
    elseif event(i,1)==786
        label(event(i,2):(event(i,2)+event(i,3)),1)=786;
    end
end

end


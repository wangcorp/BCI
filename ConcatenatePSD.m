function [ PSD, event ] = ConcatenatePSD( PSD1, PSD2, PSD3, h1, h2, h3 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
PSD = [PSD1;PSD2;PSD3];

eventType = [h1.EVENT.TYP; h2.EVENT.TYP; h3.EVENT.TYP];
eventPOS = [h1.EVENT.POS; h2.EVENT.POS+length(PSD1); h3.EVENT.POS+length(PSD1)+length(PSD2)];
eventDUR = [h1.EVENT.DUR; h2.EVENT.DUR; h3.EVENT.DUR;];
 
event =[eventType, eventPOS, eventDUR];

end


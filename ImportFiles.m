function [filename] = ImportFiles()
%importFiles extracts files from windows
%   Go get files in windows and add names to them

filename = uigetfile('*.gdf;*.mat',...
   'Select One or More Files', ...
   'MultiSelect', 'on');

end


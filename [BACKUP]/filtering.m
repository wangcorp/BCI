%bandpass filter from 8Hz to 12Hz
%[b, a] = butter(4, [8,12]/512/2); %fvtool(b,a) to visualize
%the respoonse is unstable (the filter peak is not a plateau)
%the window is too small, the order is too high

[b, a] = butter(2, [8,12]/512/2);
fvtool(b, a);


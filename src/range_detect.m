%% Range Detection Script

% run radar_param;
% run doppler_fft;

%% -------------------------
%% Integrate over Doppler
%% -------------------------
range_profile = mean(abs(RD_map), 2);

%% -------------------------
%% Threshold Detection
%% -------------------------
th_range = 0.3 * max(range_profile);
range_idx = find(range_profile > th_range);
detected_ranges = range_axis(range_idx);

fprintf('\nDetected Ranges (m):\n');
disp(detected_ranges.');
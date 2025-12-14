%% Range Detection Script - UPDATED

% run radar_param;
% run doppler_fft;

fprintf('\n========== RANGE DETECTION ==========\n');

RD_abs = abs(RD_map);
RD_dB = 20*log10(RD_abs + eps);

%% Detect range peaks using max projection
range_profile = max(abs(RD_map), [], 2);
range_profile_dB = 20*log10(range_profile);

% Adaptive threshold
noise_floor = median(range_profile_dB);
threshold_dB = noise_floor + 20;  % 20 dB above noise

% Find local maxima in range profile
win_size = 15;  % Window size for peak finding
range_idx = [];
detected_ranges = [];

for r = (win_size+1)/2 : length(range_profile) - (win_size-1)/2
    r_start = r - (win_size-1)/2;
    r_end = r + (win_size-1)/2;
    
    local_region = range_profile_dB(r_start:r_end);
    
    % Check if center is local maximum AND above threshold
    if range_profile_dB(r) == max(local_region) && ...
       range_profile_dB(r) > threshold_dB
        range_idx = [range_idx; r];
        detected_ranges = [detected_ranges; range_axis(r)];
    end
end

fprintf('Noise floor: %.2f dB\n', noise_floor);
fprintf('Threshold: %.2f dB\n', threshold_dB);
fprintf('\nDetected %d range peaks:\n', length(detected_ranges));
for i = 1:length(detected_ranges)
    fprintf('  Range %d: %.2f m (SNR: %.1f dB)\n', ...
        i, detected_ranges(i), range_profile_dB(range_idx(i)) - noise_floor);
end
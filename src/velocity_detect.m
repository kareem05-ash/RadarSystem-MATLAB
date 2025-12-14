%% Velocity Detection Script - UPDATED

% run radar_param;
% run doppler_fft;
% run range_detect;  % Must run this first to get range_idx

fprintf('\n========== VELOCITY DETECTION ==========\n');

if ~exist('range_idx', 'var') || isempty(range_idx)
    fprintf('No ranges detected. Run range_detect first.\n');
    return;
end

detected_velocities = [];
detected_pairs = [];

for i = 1:length(range_idx)
    r_bin = range_idx(i);
    doppler_slice = abs(RD_map(r_bin, :));
    doppler_slice_dB = 20*log10(doppler_slice);
    
    % Adaptive threshold for velocity
    noise_floor_vel = median(doppler_slice_dB);
    th_vel_dB = noise_floor_vel + 15;  % 15 dB above noise
    
    % Find velocity peaks with local maxima
    win_vel = 11;
    for v = (win_vel+1)/2 : N - (win_vel-1)/2
        v_start = v - (win_vel-1)/2;
        v_end = v + (win_vel-1)/2;
        
        local_region = doppler_slice_dB(v_start:v_end);
        
        % Check if local maximum AND above threshold
        if doppler_slice_dB(v) == max(local_region) && ...
           doppler_slice_dB(v) > th_vel_dB
            
            detected_velocities = [detected_velocities; vel_axis(v)];
            detected_pairs = [detected_pairs; range_axis(r_bin), vel_axis(v)];
        end
    end
end

fprintf('Detected %d targets:\n', size(detected_pairs, 1));
for i = 1:size(detected_pairs, 1)
    fprintf('  Target %d: R=%.2f m, V=%.2f m/s\n', ...
        i, detected_pairs(i,1), detected_pairs(i,2));
end
%% Main Radar Simulation
clear; clc; close all;

run radar_param;
run tx_gen;
run rx_gen;
run mf_freq;    %run mf_time;
run doppler_fft;

run range_detect;
run velocity_detect;
run plt;
%% DIAGNOSTIC - Check if targets exist in RD map
fprintf('\n========== DIAGNOSTIC: Target Visibility ==========\n');
for k = 1:length(target)
    [~, r_idx] = min(abs(range_axis - target(k).R));
    [~, v_idx] = min(abs(vel_axis - target(k).V));
    
    % Check 5x5 region around expected location
    r_range = max(1, r_idx-2):min(size(RD_map,1), r_idx+2);
    v_range = max(1, v_idx-2):min(size(RD_map,2), v_idx+2);
    
    local_max = max(max(abs(RD_map(r_range, v_range))));
    fprintf('Target %d (R=%.1fm, V=%.1fm/s): Peak in RD map = %.1f dB\n', ...
        k, target(k).R, target(k).V, 20*log10(local_max));
end
fprintf('=====================================================\n\n');
disp('===== RADAR SIMULATION COMPLETED SUCCESSFULLY =====');
%% Velocity Detection Script

% run radar_param;
% run doppler_fft;

%% -------------------------
%% Find Strongest Range Bin
%% -------------------------
[~, r_idx] = max(mean(abs(RD_map), 2));

doppler_slice = abs(RD_map(r_idx, :));

%% -------------------------
%% Velocity Detection
%% -------------------------
th_vel = 0.3 * max(doppler_slice);
vel_idx = find(doppler_slice > th_vel);
detected_velocities = vel_axis(vel_idx);

fprintf('\nDetected Velocities (m/s):\n');
disp(detected_velocities.');
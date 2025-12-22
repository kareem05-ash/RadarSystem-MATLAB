%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 7. Bonus-Section (Detection of Ranges & Velocites)
%% =========================================================================
% Find peaks for fast-axis
[peaks, peak_indices] = findpeaks(range_fft_mag_half, ...
  'SortStr', 'descend', 'NPeaks', 2, ...
  'MinPeakHeight', max(range_fft_mag_half)*0.1);

% Find peaks for slow-axis
[doppler_peaks, doppler_indices] = findpeaks(doppler_fft_mag_shifted, ...
  'SortStr', 'descend', 'NPeaks', 2, ...
  'MinPeakHeight', max(doppler_fft_mag_shifted)*0.1);

detected_targets = struct([]);

for k = 1:length(target)
  % Find nearest bins to expected target location
  [~, range_idx] = min(abs(range_axis_display - target(k).R));
  [~, vel_idx]   = min(abs(velocity_axis_display - target(k).V));
  % Local search window (bins)
  search_range = 8;
  search_vel   = 8;
  range_start = max(1, range_idx - search_range);
  range_end   = min(length(range_axis_display), range_idx + search_range);
  vel_start   = max(1, vel_idx   - search_vel);
  vel_end     = min(length(velocity_axis_display), vel_idx + search_vel);
  % Extract local Range-Doppler region
  search_region = rd_mag_display(range_start:range_end, ...
    vel_start:vel_end);
  % Find strongest peak in local region
  [max_val, max_idx] = max(search_region(:));
  [local_r, local_v] = ind2sub(size(search_region), max_idx);
  % Convert to global indices
  global_r = range_start + local_r - 1;
  global_v = vel_start   + local_v - 1;
  % Store detected parameters
  detected_targets(k).R = range_axis_display(global_r);
  detected_targets(k).V = velocity_axis_display(global_v);
  detected_targets(k).magnitude = max_val;
end

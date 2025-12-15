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

% Look for peaks near expected target locations
detected_targets = [];

% Search around each expected target
for k = 1:2
  % Find closest range bin
  [~, range_idx] = min(abs(range_axis_display - target(k).R));
  % Find closest velocity bin
  [~, vel_idx] = min(abs(velocity_axis_display - target(k).V));

  % Search in a small window around expected location
  search_range = 10;  % bins
  search_vel = 10;    % bins

  range_start = max(1, range_idx - search_range);
  range_end = min(length(range_axis_display), range_idx + search_range);
  vel_start = max(1, vel_idx - search_vel);
  vel_end = min(length(velocity_axis_display), vel_idx + search_vel);

  % Extract search region
  search_region = rd_mag_display(range_start:range_end, vel_start:vel_end);

  % Find maximum in search region
  [max_val, max_idx] = max(search_region(:));
  [local_range_idx, local_vel_idx] = ind2sub(size(search_region), max_idx);

  % Convert to global indices
  global_range_idx = range_start + local_range_idx - 1;
  global_vel_idx = vel_start + local_vel_idx - 1;

  % Get detected values
  R_detected = range_axis_display(global_range_idx);
  v_detected = velocity_axis_display(global_vel_idx);

  detected_targets(k).R = R_detected;
  detected_targets(k).V = v_detected;
  detected_targets(k).magnitude = max_val;
end
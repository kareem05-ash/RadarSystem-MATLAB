%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 6. Range Velocity Diagram
%% =========================================================================
window_2d_range = hamming(Nfast);
window_2d_doppler = hamming(N);
window_2d = window_2d_range .* window_2d_doppler';
% Apply windowing
rx_windowed = rx_sig .* window_2d;
% Range FFT Fast-Axis
range_fft_2d = fft(rx_windowed, Nfast, 1);

% Doppler FFT Slow-Axis
doppler_fft_2d = fft(range_fft_2d, N, 2);
rd_matrix = fftshift(doppler_fft_2d, 2);
rd_mag = abs(rd_matrix);

% Range axis
range_res = c / (2 * Bw);  % Theoretical range resolution
range_axis = (0:Nfast-1) * (c/(2*Bw)) * (fs/Nfast) * Tch;

% Velocity axis (after fftshift)
velocity_bins = -N/2:N/2-1;
velocity_axis = velocity_bins * (lambda * PRF) / (2 * N);

% Limit to reasonable ranges for display
range_max_display = 250;  % meters
velocity_max_display = 100;  % m/s

% Find indices for display limits
range_display_idx = find(range_axis <= range_max_display, 1, 'last');
vel_display_idx_pos = find(velocity_axis <= velocity_max_display, 1, 'last');
vel_display_idx_neg = find(velocity_axis >= -velocity_max_display, 1, 'first');

% Extract subset for display
range_axis_display = range_axis(1:range_display_idx);
velocity_axis_display = velocity_axis(vel_display_idx_neg:vel_display_idx_pos);
rd_mag_display = rd_mag(1:range_display_idx, vel_display_idx_neg:vel_display_idx_pos);
%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

%% Plotting Script
% Generates all required figures:
% 1) Transmitted pulse (real part) vs time
% 2) Received signal (single pulse) vs time
% 3) Range-Time diagram
% 4) Doppler spectrum for detected targets
% 5) Range-Doppler map with detected targets marked

% %% Load Required Data
% run radar_param;
% run tx_gen;
% run rx_gen;
% run doppler_fft;
% run detect_range;
% run detect_velocity;

%% =========================================================
%% 1) Transmitted Pulse (Real Part) vs Time
%% =========================================================
figure;
plot(t_fast * 1e6, real(tx_chirp), 'LineWidth', 1.5);
xlabel('Time (\mus)');
ylabel('Amplitude');
title('Transmitted LFM Chirp (Real Part)');
grid on;

%% =========================================================
%% 2) Received Signal for One Pulse vs Time
%% =========================================================
pulse_idx = 1;   % First pulse
figure;
plot((0:Npri-1)*Ts*1e6, real(rx_mat(:, pulse_idx)), 'LineWidth', 1);
xlabel('Time (\mus)');
ylabel('Amplitude');
title('Received Signal (Single Pulse)');
grid on;

%% =========================================================
%% 3) Range-Time Diagram (All Pulses)
%% =========================================================
figure;
imagesc((0:N-1)*PRI*1e3, range_axis, abs(rx_fast));
xlabel('Slow Time (ms)');
ylabel('Range (m)');
title('Range-Time Intensity Diagram');
axis xy;
colorbar;

%% =========================================================
%% 4) Doppler Spectrum for Each Detected Target
%% =========================================================
figure;
hold on;
for i = 1:length(range_idx)
  r_bin = range_idx(i);
  doppler_slice = abs(RD_map(r_bin, :));
  plot(vel_axis, doppler_slice ./ max(doppler_slice), ...
    'LineWidth', 1.5, ...
    'DisplayName', sprintf('Target at R = %.1f m', range_axis(r_bin)));
end
xlabel('Velocity (m/s)');
ylabel('Normalized Magnitude');
title('Doppler Spectrum of Detected Targets');
legend;
grid on;
hold off;

%% =========================================================
%% 5) Range-Doppler Map with Detected Targets
%% =========================================================
figure;
imagesc(range_axis, vel_axis, 20*log10(abs(RD_map.')));
xlabel('Range (m)');
ylabel('Velocity (m/s)');
title('Range-Doppler Map');
axis xy;
colorbar;
colormap jet;
hold on;

% Mark detected targets
for i = 1:length(range_idx)
  for j = 1:length(vel_idx)
    plot(range_axis(range_idx(i)), ...
      vel_axis(vel_idx(j)), ...
      'rx', 'MarkerSize', 10, 'LineWidth', 2);
  end
end

hold off;
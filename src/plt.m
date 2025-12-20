%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 8. Plot All Required Signals 
%% =========================================================================


zoom_samples = 1:min(500, length(t_fast));  % First 500 samples

%% 1. TX Signal
figure("Name", "TX");
plot(t_fast(zoom_samples)*1e6, real(tx_chirp(zoom_samples)), 'b', 'LineWidth', 1.5);
xlabel('Time (μs)');
ylabel('Amplitude');
title('TX FMCW Chirp (Real Part)');
grid on;

%% 2. RX Signal
rx_first_chirp = rx_sig(:, 1);
figure("Name", "RX");
plot(t_fast(zoom_samples)*1e6, real(rx_first_chirp(zoom_samples)), 'b', 'LineWidth', 1.5);
xlabel('Time (μs)');
ylabel('Amplitude');
title('RX FMCW Chirp (Real Part)');
grid on;

%% 3. Fast-Axis FFT (Range Profile)
figure("Name", "FastAxis_FFT");
plot(R_fft_half, range_fft_mag_half, 'b', 'LineWidth', 1.5);
xlabel("Range (m)");
ylabel("Magnitude");
title("Fast-Axis FFT (Range Domain)");
grid on;
xlim([0, 100]);

% Mark peaks
hold on;
for i = 1:min(2, length(peak_indices))
  R_detected = R_fft_half(peak_indices(i));
  f_beat_detected = fbeat_half(peak_indices(i));
  plot(R_detected, peaks(i), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
  text(R_detected, peaks(i)*1.05, ...
    sprintf('R=%.1f m\nf_b=%.1f MHz', R_detected, f_beat_detected/1e6), ...
    'FontSize', 8, 'HorizontalAlignment', 'center', 'BackgroundColor', 'white');
end

% Mark expected ranges
for k = 1:length(target)
  xline(target(k).R, 'g--', 'LineWidth', 1);
end
hold off;
legend('Range Profile', 'Detected Peaks', 'Expected Ranges', 'Location', 'northeast');

%% 4. Slow-Axis FFT (Velocity Profile)
figure("Name", "SlowAxis_FFT");
plot(velocity, doppler_fft_mag_shifted, 'b', 'LineWidth', 1.5);
xlabel("Velocity (m/s)");
ylabel("Magnitude");
title("Slow-Axis FFT (Velocity Domain)");
grid on;
xlim([-100, 100]);

% Mark peaks
hold on;
for i = 1:min(2, length(doppler_indices))
  v_detected = velocity(doppler_indices(i));
  f_doppler_detected = doppler_freq(doppler_indices(i));
  plot(v_detected, doppler_peaks(i), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
  text(v_detected, doppler_peaks(i)*1.05, ...
    sprintf('v=%.1f m/s\nf_d=%.1f kHz', v_detected, f_doppler_detected/1e3), ...
    'FontSize', 8, 'HorizontalAlignment', 'center', 'BackgroundColor', 'white');
end

% Mark expected velocities
for k = 1:length(target)
  xline(target(k).V, 'g--', 'LineWidth', 1);
end
hold off;
legend('Doppler Spectrum', 'Detected Peaks', 'Expected Velocities', 'Location', 'northeast');

%% 5. Range-Velocity Diagram (2D FFT)
figure("Name", "2D");
imagesc(velocity_axis_display, range_axis_display, 20*log10(rd_mag_display + eps));
xlabel('Velocity (m/s)');
ylabel('Range (m)');
title('Range-Velocity Diagram (Range-Doppler Map)');
colorbar;
axis xy;
colormap('jet');
clim([-20, max(20*log10(rd_mag_display(:) + eps))]);

% Mark targets
hold on;
for k = 1:length(target)
  % Expected (red x)
  plot(target(k).V, target(k).R, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
  
  % Detected (yellow circle)
  if k <= length(detected_targets)
    plot(detected_targets(k).V, detected_targets(k).R, 'yo', ...
      'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'yellow');
    text(detected_targets(k).V, detected_targets(k).R + 2, ...
      sprintf('T%d\nR=%.1f m\nv=%.1f m/s', k, detected_targets(k).R, detected_targets(k).V), ...
      'FontSize', 8, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
      'BackgroundColor', 'white', 'EdgeColor', 'black');
  end
end
hold off;
grid on;

%% 6. Print Results
fprintf('\n========== DETECTION RESULTS ==========\n');

fprintf('\nFast-Axis FFT (Range):\n');
for i = 1:min(2, length(peak_indices))
  R_det = R_fft_half(peak_indices(i));
  fprintf('  Peak %d: R=%.1f m (expected %.1f m), Error=%.2f m\n', ...
    i, R_det, target(i).R, abs(R_det - target(i).R));
end

fprintf('\nSlow-Axis FFT (Velocity):\n');
for i = 1:min(2, length(doppler_indices))
  v_det = velocity(doppler_indices(i));
  fprintf('  Peak %d: V=%.1f m/s (expected %.1f m/s), Error=%.2f m/s\n', ...
    i, v_det, target(i).V, abs(v_det - target(i).V));
end

fprintf('\nRange-Velocity Map:\n');
for k = 1:min(length(target), length(detected_targets))
  fprintf('  Target %d: R=%.1f m, V=%.1f m/s\n', ...
    k, detected_targets(k).R, detected_targets(k).V);
  fprintf('    Errors: ΔR=%.2f m, ΔV=%.2f m/s\n', ...
    abs(detected_targets(k).R - target(k).R), ...
    abs(detected_targets(k).V - target(k).V));
end

fprintf('\n========== SUMMARY ==========\n');
fprintf('Range Resolution: %.3f m\n', dR);
fprintf('Velocity Resolution: %.3f m/s\n', dV);
fprintf('Max Range: %.1f m\n', Rmax);
fprintf('Max Velocity: %.1f m/s\n', Vmax);
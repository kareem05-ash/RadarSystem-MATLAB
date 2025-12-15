%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 8. Plot All Required Signals
%% =========================================================================

%% 6.1: Real Part of TX FMCW (one chirp)
figure("Name", "TX");
plot(t_fast*1e6, real(tx_chirp), 'b', 'LineWidth', 1.5);
xlabel('Time (us)');
ylabel('Amplitde');
title('TX FMCW Chirp (Real Part)');
grid on;

%% 6.2: Real Part of RX FMCW (one chirp) (summation of two targets)
rx_first_chirp = rx_sig(:, 1);
figure("Name", "RX");
plot(t_fast*1e9, real(rx_chirp), 'b', 'LineWidth', 1.5);
xlabel('Time (us)');
ylabel('Amplitde');
title('RX FMCW Chirp (Real Part)');
grid on;
%% 6.3: Fast-Axis FFT (beat frequency)
figure("Name", "FastAxis_FFT");
plot(R_fft_half, range_fft_mag_half, 'b', 'LineWidth', 1.5);
xlabel("Range (m)");
ylabel("Magnitude");
title("Fast-Axis FFT (Range Domain)");
grid on;
% mark peaks
hold on;
detected_ranges = [];
for i = 1:min(2, length(peak_indices))
  R_detected = R_fft_half(peak_indices(i));
  f_beat_detected = fbeat_half(peak_indices(i));
  detected_ranges = [detected_ranges, R_detected];
  plot(R_detected, peaks(i), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
  text(R_detected, peaks(i)*1.05, ...
    sprintf('R=%.1f m\nf_b=%.1f MHz', ...
    R_detected, f_beat_detected/1e6), ...
    'FontSize', 8, 'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white');
end
% Mark expected ranges
for k = 1:2
  plot([target(k).R, target(k).R], [0, max(range_fft_mag_half)], ...
    'g--', 'LineWidth', 1);
end
hold off;

legend('Range Profile', 'Detected Peaks', 'Expected Ranges', ...
  'Location', 'northeast', 'FontSize', 8);

%% 6.4: Slow-Axis FFT (doppler frequency)
figure("Name", "SlowAxis_FFT");
plot(velocity, doppler_fft_mag_shifted, 'b', 'LineWidth', 1.5);
xlabel("Velocity (m/s)");
ylabel("Magnitude");
title("Slow-Axis FFT (Velocity Domain)");
grid on;
xlim([-100, 100]);
% Mark peaks
hold on;
detected_velocities = [];
for i = 1:min(2, length(doppler_indices))
  v_detected = velocity(doppler_indices(i));
  f_doppler_detected = doppler_freq(doppler_indices(i));
  detected_velocities = [detected_velocities, v_detected];

  plot(v_detected, doppler_peaks(i), 'ro', 'MarkerSize', 10, 'LineWidth', 2);

  text(v_detected, doppler_peaks(i)*1.05, ...
    sprintf('v=%.1f m/s\nf_d=%.1f kHz', ...
    v_detected, f_doppler_detected/1e3), ...
    'FontSize', 8, 'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'white');
end
% Mark expected velocities
for k = 1:2
  plot([target(k).V, target(k).V], [0, max(doppler_fft_mag_shifted)], ...
    'g--', 'LineWidth', 1);
end
hold off;

legend('Doppler Spectrum', 'Detected Peaks', 'Expected Velocities', ...
  'Location', 'northeast', 'FontSize', 8);

%% 6.5: Range-Velocity Diagram (2D FFT)
figure("Name", "2D");
imagesc(velocity_axis_display, range_axis_display, 20*log10(rd_mag_display + eps));
xlabel('Velocity (m/s)');
ylabel('Range (m)');
title('Range-Velocity Diagram (Range-Doppler Map)');
colorbar;
axis xy;
colormap('jet');
clim([-20, max(20*log10(rd_mag_display(:) + eps))]);  % Set color scale

% Mark detected and expected targets
hold on;
for k = 1:2
  % Plot expected target (red x)
  plot(target(k).V, target(k).R, 'rx', ...
    'MarkerSize', 12, 'LineWidth', 2);

  % Plot detected target (yellow circle)
  if k <= length(detected_targets)
    plot(detected_targets(k).V, detected_targets(k).R, 'yo', ...
      'MarkerSize', 10, 'LineWidth', 2, ...
      'MarkerFaceColor', 'yellow');

    % Add text label
    text(detected_targets(k).V, detected_targets(k).R + 2, ...
      sprintf('T%d\nR=%.1f m\nv=%.1f m/s', ...
      k, detected_targets(k).R, detected_targets(k).V), ...
      'FontSize', 8, 'FontWeight', 'bold', ...
      'HorizontalAlignment', 'center', ...
      'BackgroundColor', 'white', 'EdgeColor', 'black');
  end
end
grid on;


%% 4.6 Display detection results
fprintf('\n========== DETECTION RESULTS ==========\n');

fprintf('\nFrom Fast-Axis FFT (Range Profile):\n');
for i = 1:min(2, length(peak_indices))
  R_det = R_fft_half(peak_indices(i));
  f_beat = fbeat_half(peak_indices(i));
  fprintf('  Peak %d: Range = %.1f m, f_beat = %.1f MHz\n', ...
    i, R_det, f_beat/1e6);

  if i <= 2
    R_error = abs(R_det - target(i).R);
    fprintf('     Expected: %.1f m, Error: %.2f m (%.1f%% of resolution)\n', ...
      target(i).R, R_error, (R_error/dR)*100);
  end
end

fprintf('\nFrom Slow-Axis FFT (Doppler Spectrum):\n');
for i = 1:min(2, length(doppler_indices))
  v_det = velocity(doppler_indices(i));
  f_det = doppler_freq(doppler_indices(i));
  fprintf('  Peak %d: Velocity = %.1f m/s, f_doppler = %.1f kHz\n', ...
    i, v_det, f_det/1e3);

  if i <= 2
    v_error = abs(v_det - target(i).V);
    fprintf('     Expected: %.1f m/s, Error: %.2f m/s (%.1f%% of resolution)\n', ...
      target(i).V, v_error, (v_error/dV)*100);
  end
end

fprintf('\nFrom Range-Velocity Diagram:\n');
for k = 1:min(2, length(detected_targets))
  fprintf('  Target %d:\n', k);
  fprintf('    Detected: Range = %.1f m, Velocity = %.1f m/s\n', ...
    detected_targets(k).R, detected_targets(k).V);
  fprintf('    Expected: Range = %.1f m, Velocity = %.1f m/s\n', ...
    target(k).R, target(k).V);

  R_error = abs(detected_targets(k).R - target(k).R);
  v_error = abs(detected_targets(k).V - target(k).V);

  fprintf('    Range Error: %.2f m (%.1f%% of resolution)\n', ...
    R_error, (R_error/dR)*100);
  fprintf('    Velocity Error: %.2f m/s (%.1f%% of resolution)\n', ...
    v_error, (v_error/dV)*100);
end

fprintf('\n========== SUMMARY ==========\n');
fprintf('Theoretical Range Resolution: %.3f m\n', dR);
fprintf('Theoretical Velocity Resolution: %.3f m/s\n', dV);
fprintf('Maximum Unambiguous Range: %.1f m\n', Rmax);
fprintf('Maximum Unambiguous Velocity: %.1f m/s\n', Vmax);
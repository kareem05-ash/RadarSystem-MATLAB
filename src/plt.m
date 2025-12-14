%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

fprintf('\n========== GENERATING PLOTS ==========\n');

%% Plot 1: Transmitted Chirp
figure('Name', 'TX Chirp', 'Position', [100, 100, 800, 500]);
plot(t_fast*1e6, real(tx_chirp), 'b', 'LineWidth', 1.5);
xlabel('Time (µs)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
title('Transmitted FMCW Chirp (Real Part)', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

%% Plot 2: TX vs RX Comparison
figure('Name', 'TX-RX', 'Position', [150, 150, 800, 500]);
plot(t_fast*1e6, real(tx_sig(:,1)), 'b', 'LineWidth', 1.5); hold on;
plot(t_fast*1e6, real(rx_sig(:,1)), 'r', 'LineWidth', 1.5);
legend('TX Signal', 'RX Signal', 'FontSize', 11);
xlabel('Time (µs)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
title('TX vs RX Signal (First Chirp, Real Part)', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

%% Plot 3: Range Profile with Detection
figure('Name', 'Range Profile', 'Position', [200, 200, 800, 500]);
plot(range_axis, 20*log10(range_profile), 'b', 'LineWidth', 1.5);
hold on;
plot([0 max(range_axis)], [threshold_dB threshold_dB], 'r--', 'LineWidth', 1.5);
if exist('detected_ranges', 'var') && ~isempty(detected_ranges)
    for i = 1:length(detected_ranges)
        plot(detected_ranges(i), range_profile_dB(range_idx(i)), 'ro', ...
            'MarkerSize', 10, 'LineWidth', 2);
    end
    legend('Range Profile', 'Threshold', 'Detected Peaks', 'FontSize', 11);
else
    legend('Range Profile', 'Threshold', 'FontSize', 11);
end
xlabel('Range (m)', 'FontSize', 12);
ylabel('Magnitude (dB)', 'FontSize', 12);
title('Range Profile with Peak Detection', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
xlim([0 min(200, max(range_axis))]);

%% Plot 4: Doppler Spectrum at Detected Ranges
if exist('range_idx', 'var') && ~isempty(range_idx)
    figure('Name', 'Doppler', 'Position', [250, 250, 800, 500]);
    hold on;
    colors = lines(length(range_idx));
    for i = 1:min(5, length(range_idx))
        r_bin = range_idx(i);
        doppler_slice = abs(RD_map(r_bin, :));
        plot(vel_axis, 20*log10(doppler_slice), ...
            'LineWidth', 2, 'Color', colors(i,:), ...
            'DisplayName', sprintf('R = %.1f m', range_axis(r_bin)));
    end
    xlabel('Velocity (m/s)', 'FontSize', 12);
    ylabel('Magnitude (dB)', 'FontSize', 12);
    title('Doppler Spectrum at Detected Ranges', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'best', 'FontSize', 11);
    grid on;
    xlim([-100 100]);
end

%% Plot 5: Range-Doppler Map
figure('Name', 'RD Map', 'Position', [300, 300, 900, 600]);
RD_dB = 20*log10(abs(RD_map) + eps);
imagesc(vel_axis, range_axis, RD_dB);
xlabel('Velocity (m/s)', 'FontSize', 12);
ylabel('Range (m)', 'FontSize', 12);
title('Range-Doppler Map with Detections', 'FontSize', 14, 'FontWeight', 'bold');
axis xy;
h = colorbar;
ylabel(h, 'Magnitude (dB)', 'FontSize', 11);
colormap jet;
noise_floor_map = median(RD_dB(:));
caxis([noise_floor_map, max(RD_dB(:))]);
hold on;

% Mark detected targets
if exist('detected_pairs', 'var') && ~isempty(detected_pairs)
    for i = 1:size(detected_pairs, 1)
        plot(detected_pairs(i,2), detected_pairs(i,1), ...
            'rx', 'MarkerSize', 15, 'LineWidth', 3);
    end
end

% Mark ground truth
for k = 1:length(target)
    plot(target(k).V, target(k).R, 'wo', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
legend('Detected', 'Ground Truth', 'FontSize', 11, 'Location', 'northeast');
xlim([-100 100]);
ylim([0 min(200, max(range_axis))]);

%% Plot 6: Beat Signal
figure('Name', 'Beat Signal', 'Position', [350, 350, 800, 500]);
beat_sig = tx_sig .* conj(rx_sig);
plot(t_fast*1e6, real(beat_sig(:,1)), 'b', 'LineWidth', 1.5);
xlabel('Time (µs)', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
title('Beat Signal (Dechirped, First Chirp)', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

fprintf('All plots generated successfully!\n\n');
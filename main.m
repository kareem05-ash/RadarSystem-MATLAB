%% Pulse Doppler Radar Project - Main Execution Script (main.m)
clear; close all; clc;

% Add utils folder to path
addpath('utils');

% --- 1. SETUP: Load Parameters and Scenario ---
fprintf('--- 1. PROJECT SETUP ---\n');

% Load parameters (defined variables like PRI, Fc, N_pulses, Ts, R_max, etc.)
radar_parameters; 
% Load target scenario (Target structure array)
target_scenario; 

% Pack essential parameters into a structure for easier function passing
radar_params = struct('c', c, 'Fc', Fc, 'PRI', PRI, 'N_pulses', N_pulses, ...
                      'N_fast_time', N_fast_time, 'Ts', Ts, 'SNR_dB', SNR_dB, ...
                      'Range_fast_axis', Range_fast_axis, 'Velocity_slow_axis', Velocity_slow_axis, ...
                      'R_max', R_max); % FIX: ≈÷«›… R_max · Ã‰» Reference Error
                  
% --- 2. PART A: Signal Generation ---
fprintf('--- 2. PART A: Signal Generation ---\n');

% A. Generate Transmitted Pulse
P_t = generate_transmitted_pulse(S, Tp, Ts, N_fast_time);

% B. Generate Received Signal Matrix (R_sig: N_fast_time x N_pulses)
R_sig = generate_received_signal(P_t, Target, radar_params);

% C. Required Plots for Part A
figure(1);
plot(Time_fast_axis * 1e6, real(P_t)); 
title('Part A: Transmitted Pulse (Real Part) vs. Time');
xlabel('Time (\mus)'); ylabel('Magnitude'); grid on;

figure(2);
plot(Time_fast_axis * 1e6, real(R_sig(:, 1))); 
title('Part A: Received Signal (First Pulse)');
xlabel('Time (\mus)'); ylabel('Magnitude'); grid on;

figure(3);
% This plot needs the full 2D matrix magnitude (Range-Time Diagram)
plot_range_time(R_sig, Range_fast_axis, radar_params);


% --- 3. PART B: Range Detection and Comparison ---
fprintf('--- 3. PART B: Range Detection and Comparison ---\n');

% Initialize comparison table data
timing = struct('td', 0, 'fft', 0);
Detected_Ranges = struct('td', [], 'fft', []);

% A. Method 1: Matched Filter (Time Domain)
tic;
RC_td = range_detection_matched_filter(R_sig, P_t); 
timing.td = toc;

% B. Method 2: FFT-Based Processing (Frequency Domain)
tic;
RC_fft = range_detection_fft(R_sig, P_t);
timing.fft = toc;

% Define plotting axis consistent with N_fast_time
N_plot = radar_params.N_fast_time; 
Range_plot_axis = radar_params.Range_fast_axis(1:N_plot); 

% C. Peak Detection 
% Use the first pulse for detection. Use the N_fast_time length output.
[Detected_Ranges.td, R_td_bin] = peak_detection(abs(RC_td(1:N_plot, 1)), Range_plot_axis, 'Time Domain'); 
[Detected_Ranges.fft, R_fft_bin] = peak_detection(abs(RC_fft(1:N_plot, 1)), Range_plot_axis, 'FFT Domain');

% D. Required Plots and Tables for Part B

% Plot 4: Time Domain Method
figure(4);
plot(Range_plot_axis, abs(RC_td(1:N_plot, 1))); 
hold on;
plot(Range_plot_axis(R_td_bin), abs(RC_td(R_td_bin, 1)), 'ro', 'MarkerSize', 8);
title('Part B: Range Profile - Matched Filter (Time)');
xlabel('Range (m)'); ylabel('Magnitude'); grid on;

% Plot 5: FFT Method 
figure(5);
plot(Range_plot_axis, abs(RC_fft(1:N_plot, 1))); 
hold on;
plot(Range_plot_axis(R_fft_bin), abs(RC_fft(R_fft_bin, 1)), 'bo', 'MarkerSize', 8); 
title('Part B: Range Profile - FFT Method');
xlabel('Range (m)'); ylabel('Magnitude'); grid on;

% [Comparison Table generation logic using Detected_Ranges and timing]...


% --- 4. PART C: Velocity Estimation ---
fprintf('--- 4. PART C: Velocity Estimation ---\n');

% Use the Range Bins detected by the FFT method (RC_fft) for further processing
Target_Bins = R_fft_bin; 
Estimated_Velocities = zeros(1, length(Target_Bins));

for k = 1:length(Target_Bins)
    % RC_fft should be used here as it's the output of the first stage processing
    [V_spectrum, V_axis] = doppler_processing(RC_fft, Target_Bins(k), radar_params);
    
    % Find peak in V_spectrum to estimate Doppler Frequency/Velocity
    [max_mag, V_idx] = max(V_spectrum);
    Estimated_Velocities(k) = V_axis(V_idx);

    figure(5 + k);
    
    % Plot spectrum in dB scale 
    V_spectrum_dB = 20 * log10(V_spectrum + eps); 
    
    plot(V_axis, V_spectrum_dB);
    hold on;
    
    true_v_mark = Target(k).v;
    
    % FIX: Use a dummy variable instead of ~ for compatibility
    [dummy, true_v_idx] = min(abs(V_axis - true_v_mark)); 
    
    % Mark TRUE velocity (green star)
    plot(V_axis(true_v_idx), V_spectrum_dB(true_v_idx), 'g*', 'MarkerSize', 12, 'LineWidth', 2);
    
    % Mark DETECTED velocity (red x)
    plot(Estimated_Velocities(k), V_spectrum_dB(V_idx), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
    
    % Robust title concatenation
    title_str = ['Part C: Doppler Spectrum for Target ', num2str(k), ' (Range: ', num2str(Target(k).R), 'm)'];
    title(title_str);
    xlabel('Velocity (m/s)'); ylabel('Magnitude (dB)'); grid on;
end
% [Velocity Comparison Table generation logic]...


% --- 5. PART D: Range-Doppler Map Generation ---
fprintf('--- 5. PART D: Range-Doppler Map ---\n');

[RDM_dB, Range_axis_RDM, Velocity_axis_RDM] = range_doppler_map(R_sig, P_t, radar_params);

figure(8);
imagesc(Velocity_axis_RDM, Range_axis_RDM, RDM_dB);
axis xy; % Ensure range increases upwards and velocity is horizontal
colormap('jet'); colorbar;
title('Part D: Range-Doppler Map');
xlabel('Velocity (m/s)'); ylabel('Range (m)');
hold on;

% Mark true target locations on the map 
for k = 1:length(Target)
    % FIX: «” Œœ«„ dummy variables
    [R_min_val, R_idx_true] = min(abs(Range_axis_RDM - Target(k).R));
    [V_min_val, V_idx_true] = min(abs(Velocity_axis_RDM - Target(k).v));
    
    % Plot a marker (White Circle 'wo')
    plot(Velocity_axis_RDM(V_idx_true), Range_axis_RDM(R_idx_true), 'wo', 'MarkerSize', 10, 'LineWidth', 1.5);
end

% --- FINAL CLEANUP ---
fprintf('Project Execution Complete.\n');
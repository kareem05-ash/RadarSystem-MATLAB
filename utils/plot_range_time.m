function plot_range_time(R_sig, Range_fast_axis, radar_params)
% PLOT_RANGE_TIME: Plots the magnitude of the received signal matrix (Range-Time Diagram).
%
% Inputs:
%   R_sig:          Received signal matrix (N_fast_time x N_pulses)
%   Range_fast_axis: Range vector (m)
%   radar_params:   Structure containing necessary parameters (N_pulses, PRI)

    % Time axis for the slow-time dimension (across pulses)
    Time_slow_axis = (0:radar_params.N_pulses-1) * radar_params.PRI; 
    
    % Convert magnitude to dB scale for better visualization
    R_sig_dB = 20 * log10(abs(R_sig) + eps); % Add eps to prevent log(0)
    
    % Plot the 2D image
    imagesc(Time_slow_axis, Range_fast_axis, R_sig_dB);
    axis xy; % Ensures the range axis increases upwards
    colormap('jet'); colorbar;
    
    title('Part A: Range-Time Diagram (Received Signal Magnitude in dB)');
    xlabel('Slow Time (s) - Across Pulses');
    ylabel('Range (m) - Fast Time');
    grid on;
end
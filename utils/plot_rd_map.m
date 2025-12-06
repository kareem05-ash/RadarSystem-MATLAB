function plot_rd_map(RDM_dB, Range_axis, Velocity_axis)
% PLOT_RD_MAP: Plots the final Range-Doppler Map.
%
% Inputs:
%   RDM_dB: 2D Range-Doppler Map (Magnitude in dB)
%   Range_axis: Range vector (m)
%   Velocity_axis: Velocity vector (m/s)

    figure;
    imagesc(Velocity_axis, Range_axis, RDM_dB);
    axis xy; % Ensure range increases upwards and velocity is horizontal
    colormap('jet'); colorbar;
    
    title('Part D: Range-Doppler Map (Magnitude in dB)');
    xlabel('Velocity (m/s)'); 
    ylabel('Range (m)');
    grid on;
    
    % Optionally: Add logic here to mark detected targets
    % e.g., hold on; plot(detected_v, detected_r, 'wo', 'MarkerSize', 10);
end
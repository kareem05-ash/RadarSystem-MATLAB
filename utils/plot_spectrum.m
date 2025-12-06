% --- utils/plot_spectrum.m ---
function plot_spectrum(V_spectrum, V_axis, target_info)
% PLOT_SPECTRUM: Plots the Doppler velocity spectrum.
%
% Inputs:
%   V_spectrum: Magnitude of the Doppler spectrum
%   V_axis: Velocity axis vector (m/s)
%   target_info: Structure or string containing target details

    plot(V_axis, V_spectrum);
    
    % Use a relevant title structure
    if isfield(target_info, 'R') && isfield(target_info, 'v')
        title(['Doppler Spectrum for Target (R=', num2str(target_info.R), 'm, True V=', num2str(target_info.v), 'm/s)']);
    else
        title('Doppler Velocity Spectrum');
    end

    xlabel('Velocity (m/s)'); 
    ylabel('Magnitude'); 
    grid on;
end
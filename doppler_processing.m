function [V_spectrum, V_axis] = doppler_processing(range_compress_sig, target_range_bin_idx, radar_params)
% DOPPLER_PROCESSING: Extracts velocity spectrum for a specific range bin.
%
% Inputs:
%   range_compress_sig: Range compressed signal matrix (Range_samples x N_pulses)
%   target_range_bin_idx: Index (row number) of the detected target range
%   radar_params:       Structure/Variables (PRF, N_pulses, c, Fc)
%
% Outputs:
%   V_spectrum:         Magnitude of the velocity spectrum
%   V_axis:             Velocity axis vector (m/s)

N_pulses = radar_params.N_pulses;
c = radar_params.c;
Fc = radar_params.Fc;
PRF = radar_params.PRF;

% 1. Extract the signal vector across N pulses (Slow-time axis)
S_slow_time = range_compress_sig(target_range_bin_idx, :);

% 2. Apply FFT across pulses
Doppler_spectrum = fft(S_slow_time, N_pulses);

% 3. Apply fftshift to center the zero-Doppler frequency
Doppler_spectrum_shifted = fftshift(Doppler_spectrum);

% 4. Calculate Velocity Axis
F_d_axis = linspace(-PRF/2, PRF/2, N_pulses);
V_axis = (F_d_axis * c) / (2 * Fc);

% 5. Output the magnitude spectrum
V_spectrum = abs(Doppler_spectrum_shifted);

end
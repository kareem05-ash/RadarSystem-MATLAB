function [RDM_dB, Range_axis_RDM, Velocity_axis_RDM] = range_doppler_map(R_sig, P_t, radar_params)
% RANGE_DOPPLER_MAP: Generates the 2D Range-Doppler Map (RDM).
%
% Inputs:
%   R_sig:  Received signal matrix (N_fast_time x N_pulses)
%   P_t:    Transmitted LFM pulse vector (1D)
%   radar_params: Structure/Variables (c, PRF, Fc, N_pulses, Ts, R_max, Velocity_slow_axis)
%
% Outputs:
%   RDM_dB: 2D Range-Doppler Map (Magnitude in dB)
%   Range_axis_RDM: Range vector (m) corresponding to the RDM rows
%   Velocity_axis_RDM: Velocity vector (m/s) corresponding to the RDM columns

% --- Step 1: Range Processing (Matched Filtering - FFT Method Recommended) ---
% Range Compression (Fast-time processing)
Range_compressed_sig = range_detection_fft(R_sig, P_t);
[N_range_bins, N_pulses] = size(Range_compressed_sig); 

% --- Step 2: Doppler Processing (FFT across pulses) ---
% Apply FFT along dimension 2 (Slow-time)
RDM_complex = fft(Range_compressed_sig, N_pulses, 2); 

% --- Step 3: Shift Doppler Axis ---
% Apply fftshift to center the zero-Doppler frequency
RDM_shifted = fftshift(RDM_complex, 2);

% --- Step 4: Calculate Magnitude in dB and Axes ---
% Magnitude in dB scale
RDM_dB = 20 * log10(abs(RDM_shifted) + eps); 

% FIX: Calculate Range Axis based on true R_max and the new number of bins (N_range_bins = N_fft)
R_max_unambig = radar_params.R_max; 
Range_axis_RDM = linspace(0, R_max_unambig, N_range_bins);

% Velocity Axis (Already calculated correctly in radar_parameters.m)
Velocity_axis_RDM = radar_params.Velocity_slow_axis; 

end
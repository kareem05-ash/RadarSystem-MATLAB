% =========================================================================
% radar_parameters.m
% Optimized Radar System Parameters for Pulse-Doppler Radar Simulation
% ELC 2030 - Fall 2025
% =========================================================================

function params = radar_parameters()
    % RADAR_PARAMETERS - Define all radar system parameters
    %
    % Outputs:
    %   params - Structure containing all radar parameters
    
    fprintf('Setting up radar parameters...\n');
    
    %% ==================== BASIC RADAR PARAMETERS ========================
    params.c = 3e8;                     % Speed of light [m/s]
    
    %% 1. CARRIER FREQUENCY
    params.fc = 10e9;                   % Carrier frequency [Hz] - X-band (10 GHz)
    
    %% 2. PULSE PARAMETERS
    params.Tp = 2e-6;                   % Pulse width [s] - 2 microseconds
    params.BW = 50e6;                   % Bandwidth [Hz] - 50 MHz
    
    %% 3. PULSE REPETITION PARAMETERS (OPTIMIZED)
    % Target: v_max ? 100 m/s without Doppler aliasing
    % v_max = c * PRF / (4 * fc)
    % PRF = 4 * v_max * fc / c
    desired_vmax = 100; % [m/s]
    params.PRF = 4 * desired_vmax * params.fc / params.c;   % ? 13.33 kHz
    params.PRI = 1 / params.PRF;                             % PRI from PRF
    
    %% 4. WAVEFORM TYPE
    params.waveform_type = 'rectangular'; % Pulse waveform
    
    %% 5. NUMBER OF PULSES
    params.N_pulses = 256;                % Pulses in one CPI (good Doppler resolution)
    
    %% ==================== DERIVED PARAMETERS ===========================
    
    %% 6. MAXIMUM UNAMBIGUOUS RANGE
    params.R_max = params.c * params.PRI / 2;
    
    %% 7. MAXIMUM UNAMBIGUOUS VELOCITY (NOW CORRECT)
    params.v_max = params.c * params.PRF / (4 * params.fc);
    
    %% 8. SAMPLING PARAMETERS
    params.fs = 2 * params.BW;            % Nyquist: 2 * BW
    params.Ts = 1 / params.fs;
    
    params.Ns_per_pulse = ceil(params.Tp / params.Ts);
    params.Ns_per_PRI   = ceil(params.PRI / params.Ts);
    
    %% 9. RESOLUTION PARAMETERS
    params.range_resolution   = params.c / (2 * params.BW);
    params.doppler_resolution = params.PRF / params.N_pulses;
    
    %% ==================== NOISE PARAMETERS =============================
    params.SNR_dB = 10;   % 10 dB SNR
    
    %% ==================== VALIDATION CHECKS ============================
    
    % 1) Doppler aliasing check
    max_expected_v = 80;  % expected target max speed
    max_expected_fd = 2 * max_expected_v * params.fc / params.c;
    
    if max_expected_fd > params.PRF / 2
        warning('WARNING: Expected Doppler exceeds Nyquist. Velocity aliasing may occur.');
    end
    
    % 2) Range aliasing check
    max_target_range = 20e3;
    if max_target_range > params.R_max
        warning('WARNING: Target range exceeds R_max. Range aliasing may occur.');
    end
    
    %% ==================== DISPLAY PARAMETERS ===========================
    fprintf('\n=== OPTIMIZED RADAR SYSTEM PARAMETERS ===\n');
    fprintf('Carrier Frequency (fc): %.1f GHz\n', params.fc/1e9);
    fprintf('Pulse Width (Tp): %.2f µs\n', params.Tp*1e6);
    fprintf('Bandwidth (BW): %.1f MHz\n', params.BW/1e6)

% --- Radar System and Signal Parameters ---

% 1. Physical Constants
c = 3e8;        % Speed of light (m/s) [cite: 13]

% 2. System Requirements and Design Choices
Fc = 77e9;      % Carrier Frequency (Hz) (76-77 GHz range) [cite: 80]
R_max_target = 250; % Maximum required target range (m) [cite: 83]
Delta_R_req = 0.75; % Required Range Resolution (m) [cite: 84]
Delta_V_req = 0.5;  % Required Velocity Resolution (m/s) [cite: 85]
SNR_dB = 10;    % Signal-to-Noise Ratio (dB) (chosen in 5-15 dB range) [cite: 90]

% 3. Derived Pulse Parameters (Part a)
% A. Range Resolution & Bandwidth (B)
Bw = c / (2 * Delta_R_req);  % Required Bandwidth (Hz)
clc;

% Use a slightly higher bandwidth to ensure meeting the requirement:
B = 300e6;                  % Chosen Bandwidth (300 MHz for Delta_R = 0.5m)
Tp = 2e-6;                  % Pulse Width (s) (Choose Tp < PRI)
S = B / Tp;                 % Chirp Slope (Hz/s) [cite: 49]

% B. Range Ambiguity & Pulse Repetition Interval (PRI)
R_max_unambig_design = R_max_target * 1.5; % Ensure comfortable margin (e.g., 1.5x)
PRI = 2 * R_max_unambig_design / c; % Pulse Repetition Interval (s)
% Calculated R_max_unambig:
R_max = c * PRI / 2;        % Maximum Unambiguous Range (m) [cite: 82]

% C. Velocity Ambiguity & Pulse Repetition Frequency (PRF)
PRF = 1 / PRI;              % Pulse Repetition Frequency (Hz) [cite: 77]
V_max = c * PRF / (4 * Fc); % Maximum Unambiguous Velocity (m/s) [cite: 82]

% D. Velocity Resolution & Number of Pulses (N)
N_pulses = c / (2 * Fc * PRI * Delta_V_req); % Required minimum number of pulses
N_pulses = ceil(N_pulses); % Ensure N is an integer

% Use a round number slightly larger than the requirement for good measure
N_pulses = 2000;            % Chosen Number of Pulses (N)

% 4. Sampling Parameters
Fs = 2 * B;                 % Sampling Frequency (Hz) (Must be >= B)
Ts = 1 / Fs;                % Sampling Time (s)
N_fast_time = ceil(PRI / Ts); % Number of samples in the fast-time dimension (Range)
Time_fast_axis = 0:Ts:(N_fast_time-1)*Ts; % Time vector for a single pulse period

% 5. Calculated Axes for Plotting (Used in Part b, c, d)
% Range Axis
Range_fast_axis = c * Time_fast_axis / 2; % Range vector (m)

% Velocity/Doppler Axis (Doppler Freq from -PRF/2 to PRF/2)
F_d_axis = linspace(-PRF/2, PRF/2, N_pulses);
Velocity_slow_axis = (F_d_axis * c) / (2 * Fc); % Velocity vector (m/s) [cite: 76]

% 6. Display Calculated Parameters (Optional, for verification)
fprintf('--- RADAR PARAMETER SUMMARY ---\n');
fprintf('Carrier Freq (Fc): %.2f GHz\n', Fc/1e9);
fprintf('Chosen Bandwidth (B): %.2f MHz (Range Res: %.2f m)\n', B/1e6, c/(2*B));
fprintf('PRI: %.2f us, PRF: %.2f kHz\n', PRI*1e6, PRF/1e3);
fprintf('Max Unambiguous Range (R_max): %.2f m\n', R_max);
fprintf('Max Unambiguous Velocity (V_max): %.2f m/s\n', V_max);
fprintf('Number of Pulses (N): %d (Velocity Res: %.4f m/s)\n', N_pulses, c/(2*Fc*PRI*N_pulses));
fprintf('Sampling Freq (Fs): %.2f MHz, Fast Time Samples: %d\n', Fs/1e6, N_fast_time);
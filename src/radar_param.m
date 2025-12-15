%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 1. RADAR PARAMETERS
%% =========================================================================

%% Core Parameters
fmin = 76e9;                % Lower frequency limit (Hz)
fmax = 77e9;                % Upper frequency limit (Hz)
fc = (fmin + fmax) / 2;     % Carrier frequency (Hz)
Bw = fmax - fmin;           % Bandwidth (Hz)
c = 3e8;                    % Speed of light (m/s)
lambda = c / fc;            % Carrier wavelength (m)

%% Specs Parameters
Rmax = 250;                 % Maximum range (m)
Rmin = 0.75;                % Minimum range (m)
Vmax = 100;                 % Maximum speed (m/s)
Vmin = 0.5;                 % Minimum speed (m/s)

%% Timing Parameters
Tch = 2.1e-6;               % Chirp duration (s)
s = Bw / Tch;               % Chirp frequency slope (Hz/s)
RTTmax = (2 * Rmax) / c;    % Maximum round trip time (s)
Tw = RTTmax / 4;            % Window time (s)

%% Fast-Axis (Range) Sampling Parameters
Ts = 0.5e-9;                % Sampling time (s)
fs = 1 / Ts;                % Sampling rate (Hz)
Nfast = round(Tw / Ts);     % Number of samples on fast axis (range bins)
dfb = 1 / Tw;               % Minimum beat frequency (Hz)
dR = (c * Tch * dfb) / (2 * Bw);    % Range resolution

%% Slow-Axis (Doppler) Parameters
PRI = 4 * Tch;              % Pulse repetition interval (s)
PRF = 1 / PRI;              % Pulse repetition frequency
N = 512;                    % Number of chirps (slow-time samples)
dfd = 1 / (N * PRI);        % Minimum Doppler frequency (Hz)
dV = (lambda * dfd) / 2;    % Velocity resolution

%% Noise Parameters
SNR_dB = 15;                % SNR in dB
SNR_lin = 10^(SNR_dB/10);   % Linear SNR

%% Target Parameters
target(1).A = 1e-3;            % Amplitude of target-1
target(1).R = 50;          % Range of target-1 (m)
target(1).V = 10;           % Velocity of target-1 (m/s) [approaching]
target(1).RTT = (2 * target(1).R) / c;      % RTT for target-1 (s)
target(1).fd = (2 * target(1).V) / lambda;  % Doppler for target-1 (Hz)

target(2).A = 1e-3;            % Amplitude of target-2
target(2).R = 30;           % Range of target-2 (m)
target(2).V = -70;          % Velocity of target-2 (m/s) [receding]
target(2).RTT = (2 * target(2).R) / c;      % RTT for target-2 (s)
target(2).fd = (2 * target(2).V) / lambda;  % Doppler for target-2 (Hz)


% %% Summary
% fprintf('Carrier Frequency: %.2f GHz\n', fc/1e9);
% fprintf('Bandwidth: %.2f MHz\n', Bw/1e6);
% fprintf('Chirp Duration: %.2f µs\n', Tch*1e6);
% fprintf('Fast-time samples (Nfast): %d\n', Nfast);
% fprintf('Slow-time samples (N): %d\n', N);
% fprintf('Range Resolution: %.2f m\n', dR);
% fprintf('Velocity Resolution: %.2f m/s\n', dV);
% fprintf('SNR: %.1f dB\n', SNR_dB);
% fprintf('\nTarget 1: R=%.1fm, V=%.1fm/s, fd=%.1fHz\n', ...
%   target(1).R, target(1).V, target(1).fd);
% fprintf('Target 2: R=%.1fm, V=%.1fm/s, fd=%.1fHz\n', ...
%   target(2).R, target(2).V, target(2).fd);
%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% +201002321067
% https://github.com/kareem05-ash

%% Radar Parameters
% This script will be called from each script

%% -------------------------
%% Core Parameters
%% -------------------------
fc = 76.5e9;          % Carier Frequency (Hz)
c = 3e8;              % Speed of Light (m/s)
lambda = c / fc;      % Wavelenth (m)

%% -------------------------
%% Bw, Resolution Specs
%% -------------------------
Bw = 1e9;             % Bandwidth (Hz)
dR = c / (2 * Bw);    % Range Resolution (m)
dR_req = 0.75;        % Min. Required Range Resolution (m)
Rmax = 250;           % Maximum Range (m)
dV = 0.5;             % Min. allowed velocity


%% -------------------------
%% Timing Parameters
%% -------------------------
Tp = 1e-6;            % Chirp time (s)
PRI = 1.10 * ((2 * Rmax) / c);    % Pulse Repeatition Interval
PRF = 1 / PRI;        % Pulse Repeatition Frequency
Vmax = (c * PRF) / (4 * fc);      % Max. Unambiguous Velocity
tau_Rmax = (2 * Rmax) / c;        % Max. Round Trip Delay
slope = Bw / Tp;      % Chirp Slope

%% -------------------------
%% Sampling Parameters
%% -------------------------
fs = Bw;              % Sampling Frequency
Ts = 1 / fs;          % Sampling Time
Nfast = round(Tp * fs);           % Samples per chirp
Nmin = (PRF * c) / (2 * fc * dV); % Minimum N pulses
N = 2^nextpow2(ceil(Nmin));       % No. of Pulses
Npri = round(PRI * fs);             % Total samples per PRI

%% -------------------------
%% Target Parameters
%% -------------------------
% Target(1) Parameters
target(1).R = 50;     % Target 1: Range (m)
target(1).V = 60;     % Target 1: Velocity (m/s) approaching
target(1).tau = (2 * target(1).R) / c;    % Target 1: Time Shift (s)
target(1).fd = (2 * target(1).V) / lambda;% Target 1: Doppler Phase Shift (Hz)

% Target(2) Parameters
target(2).R = 160;    % Target 2: Range (m)
target(2).V = -20;    % Target 2: Velocity (m/s) receding
target(2).tau = (2 * target(2).R) / c;    % Target 2: Time Shift (s)
target(2).fd = (2 * target(2).V) / lambda;% Target 2: Doppler Phase Shift (Hz)

%% -------------------------
%% Noise Parameters
%% -------------------------
SNR_dB = 10;          % SNR In dB
SNR_lin = 10^(SNR_dB / 10);     % Linear SNR

%% =========================
%% Targets Parameters Validation
%% =========================
for k = 1:2
  if target(k).R < dR_req || target(k).R > Rmax
    warning('Target %d range out of allowed bounds [%g, %d] m', k, dR_req, Rmax);
  end
  if abs(target(k).V) > 100
    warning('Target %d velocity magnitude > 100 m/s', k);
  end
end

%% =========================
%% Print Summary
%% =========================

fprintf('=============== Radar Parameters Summary ===============\n');
fprintf(' > fc = %.3e Hz, lambda = %.4e m\n', fc, lambda);
fprintf(' > Bw = %.3e Hz, dR_lower_limit = %.3f m, acheived_dR = %.3f m\n', Bw, dR_req, dR);
fprintf(' > Tp = %.3e s, slope = %.3e, tau_Rmax = %.3e s, Vmax = %.3e m/s\n', Tp, slope, tau_Rmax, Vmax);
fprintf(' > PRI = %.3f s, PRF = %.3f Hz\n', PRI, PRF);
fprintf(' > fs = %.3eHz, Ts = %.3e s\n', fs, Ts);
fprintf(' > No. of Samples per Chirp = %d, No. of Samples = %d\n', Nfast, N);
fprintf(' > SNR_dB = %g dB, SNR_lin = %.3f\n', SNR_dB, SNR_lin);
for k = 1:2
  fprintf(' ========== Target (%d) ==========\n', k);
  fprintf(' > Range = %.1f m, Velocity = %.1f m/s\n', target(k).R, target(k).V);
  fprintf(' > tau = %.10f s, fd = %.3f Hz\n', target(k).tau, target(k).fd);
end
fprintf('\n========================================================\n\n');
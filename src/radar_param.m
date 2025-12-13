%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% +201002321067
% https://github.com/kareem05-ash

%% Core Parameters
fmin = 76e9;                % lower limit (Hz)
fmax = 77e9;                % upper limit (Hz)
fc = (fmin + fmax) / 2;     % carrier frequency (Hz)
Bw = fmax - fmin;           % Bandwidth (Hz)
c = 3e8;                    % speed of light (m/s)
lambda = c / fc;            % carrier wavelength (m)

%% Specs Parameters
Rmax = 250;                 % maximum range (m)
Rmin = 0.75;                % minimum range (m)
Vmax = 100;                 % maximum speed (m/s)
Vmin = 0.5;                 % minimum speed (m/s)

%% Timing Parameters
Tch = 2.1e-6;               % chirp duaration (s)
s = Bw / Tch;               % chirp frequency slope (Hz/s)
RTTmax = (2 * Rmax) / c;    % maximum round trip time (s)
Tw = RTTmax / 4;            % windo time (s)

%% Fast-Axis = Sampling Parameters
Ts = 0.5e-9;                % sampling time (s)
fs = 1 / Ts;                % sampling rate (Hz)
N = round(Tw / Ts);         % number of samples on the fast axis
dfb = 1 / Tw;               % minimum beat frequency (Hz)
dR = (c * Tch * dfb) / (2 * Bw);    % range resolution

%% Slow-Axis = Doppler Parameters
PRI = 4 * Tch;              % pulse repeatition interval (s)
PRF = 1 / PRI;              % pulse frequency
M = 512;                    % number of chirps on the slow axis
dfd = 1 / (M * PRI);        % minimum doppler frequency (Hz)
dV = lambda / (2 * dfd);    % velocity resolution

%% Noise Parameters
SNR_dB = 10;                % SNR in dB
SNR_lin = 10^(SNR_dB/10);   % linear SNR

%% Targets Parameters
target(1).A = 1;            % amplitude of target-1
target(1).R = 150;          % range of target-1 (m)
target(1).V = 60;           % velocity of target-1 (m/s) [approaching]
target(1).RTT = (2 * target(1).R) / c;      % RTT for target-1 (s)
target(1).fd = (2 * target(1).V) / lambda;  % fd for target-1 (Hz)

target(2).A = 1;            % amplitude of target-2
target(2).R = 30;           % range of target-2 (m)
target(2).V = -70;          % velocity of target-2 (m/s) [receding]
target(2).RTT = (2 * target(2).R) / c;      % RTT for target-2 (s)
target(2).fd = (2 * target(2).V) / lambda;  % fd for target-2 (Hz)

%% Summary
fprintf('\n======================================================================================\n');
fprintf('============================== Radar Parameters Summary ==============================\n');
fprintf('======================================================================================\n');
fprintf(' > fc = %.2e Hz, lambda = %.4e m, Bw = %e\n', fc, lambda, Bw);
fprintf(' > Tch = %.1e s, Tw = %.3e s, slope = %.3e, RTTmax = %.3e s\n', Tch, Tw, s, RTTmax);
fprintf(' > M _ slow-axis _ = %d, dfd = %.3e, dV = %.3e', M, dfd, dV);
fprintf(' > PRI = %.7f s, PRF = %.3f Hz\n', PRI, PRF);
fprintf(' > N _ fast-axis _ = %d, dfb = %.3e, dR = %.3e', N, dfb, dR);
fprintf(' > fs = %.3eHz, Ts = %.3e s\n', fs, Ts);
fprintf(' > SNR_dB = %g dB, SNR_lin = %.3f\n', SNR_dB, SNR_lin);
for k = 1:2
  fprintf(' ==================== Target (%d) ====================\n', k);
  fprintf(' > Amplitude = %.1f Range = %.1f m, Velocity = %.1f m/s\n', target(k).A, target(k).R, target(k).V);
  fprintf(' > RTT = %.7f s, fd = %.3f Hz\n', target(k).RTT, target(k).fd);
end
fprintf(' >> Rmax   = %.2f m\n', (c * PRI) / 2);
fprintf(' >> Vmax   = %.2f m/s\n', (c * PRF) / (4 * fc));
fprintf('======================================================================================\n');
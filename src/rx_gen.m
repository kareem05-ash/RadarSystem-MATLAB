%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

%% RX Generation Script
% This script:
%   1) Applies time delay for each target
%   2) Applies Doppler shift across pulses
%   3) Applies attenuation
%   4) Adds AWGN noise
%   5) Generates RX signal matrix & continuous signal

% %% Load Radar Parameters & TX
% run radar_param;
% run tx_gen;

%% -------------------------
%% Initialize RX Matrix
%% -------------------------
rx_mat = zeros(Npri, N);   % Received signal [Npri x N]

%% -------------------------
%% Loop over Targets
%% -------------------------
for k = 1:length(target)
  %% Target parameters
  tau = target(k).tau;         % Time delay
  fd  = target(k).fd;          % Doppler frequency
  R   = target(k).R;           % Range

  %% Convert delay to samples
  delay_samp = round(tau / Ts);

  %% Attenuation (simple 1/R^2 model)
  alpha = 1 / (R^2);

  %% Doppler phase across pulses
  doppler_phase = exp(1j * 2 * pi * fd .* t_slow);

  %% Apply target effect pulse-by-pulse
  for n = 1:N
    if delay_samp < Npri
      rx_mat(delay_samp+1:end, n) = ...
        rx_mat(delay_samp+1:end, n) + ...
        alpha * tx_mat(1:end-delay_samp, n) * doppler_phase(n);
    end
  end
end

%% -------------------------
%% Add AWGN Noise
%% -------------------------
signal_power = mean(abs(rx_mat(:)).^2);
noise_power  = signal_power / SNR_lin;
noise = sqrt(noise_power/2) * ...
  (randn(size(rx_mat)) + 1j*randn(size(rx_mat)));

rx_mat = rx_mat + noise;

%% -------------------------
%% Fast-Time Matrix (for Processing)
%% -------------------------
rx_fast = rx_mat(1:Nfast, :);   % [Nfast x N]

%% -------------------------
%% Continuous RX Signal
%% -------------------------
rx_cont = rx_mat(:);
t_rx = (0:length(rx_cont)-1).' * Ts;

%% =========================
%% RX Summary
%% =========================
fprintf('\n=============== RX Generation Summary ===============\n');
fprintf(' > Number of targets     = %d\n', length(target));
fprintf(' > RX matrix size        = [%d x %d]\n', size(rx_mat,1), size(rx_mat,2));
fprintf(' > RX fast-time size     = [%d x %d]\n', size(rx_fast,1), size(rx_fast,2));
fprintf('=====================================================\n\n');
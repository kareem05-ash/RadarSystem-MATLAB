%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 3. RX SIGNAL GENERATION
%% =========================================================================

%% Signal Generation
num_targets = length(target);
rx_sig = zeros(Nfast, N);         % Beat signal [Nfast x N]
rx_chirp = zeros(Nfast, 1);       % First beat chirp

for m = 1:N
  for k = 1:num_targets
    % Target parameters
    R = target(k).R;          % Range in meters
    V = target(k).V;          % Velocity in m/s
    A = target(k).A;          % Amplitude
    RTT = target(k).RTT;      % Round Trip Time
    f_beat = s * RTT;         % Beat frequency
    f_d = 2 * V / lambda;
    beat_signal = A * exp(1j * 2*pi * (f_beat * t_fast + f_d * (m-1) * PRI));
    rx_sig(:, m) = rx_sig(:, m) + beat_signal;
  end
end

%% Adding Gaussian Noise
signal_power = mean(abs(rx_sig(:)).^2);
noise_power = signal_power / SNR_lin;
noise = sqrt(noise_power/2) * (randn(size(rx_sig)) + 1j*randn(size(rx_sig)));
rx_sig = rx_sig + noise;

%% Generate DELAYED TX SIGNAL
rx_chirp_plot = zeros(Nfast, 1);
for k = 1:num_targets
  A = target(k).A;
  R = target(k).R;
  V = target(k).V;
  RTT = target(k).RTT;
  f_d = 2 * V / lambda;
  t_delayed = t_fast - RTT;
  % Generate delayed TX with Doppler shift
  for n = 1:Nfast
    if t_delayed(n) >= 0 && t_delayed(n) <= Tch
      rx_chirp_plot(n) = rx_chirp_plot(n) + A * exp(1j * 2*pi * ...
        (fmin * t_delayed(n) + 0.5 * s * t_delayed(n)^2 + ...
        f_d * t_fast(n)));
    end
  end
end

% Add Gaussian Noise to it
rx_chirp_plot = rx_chirp_plot + noise(:, 1);

fprintf('RX signal size with noise: [%d x %d]\n', size(rx_sig));
fprintf('SNR: %.1f dB\n', SNR_dB);
%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 2. 3. RX SIGNAL GENERATION
%% =========================================================================
fprintf('\n========== RX SIGNAL GENERATION ==========\n');

%% Signal Generation
num_targets = length(target);     % number of targets
rx_sig = zeros(Nfast, N);         % initialize the 2D matrix by zeros
rx_chirp = zeros(Nfast, 1);

for m = 1:N
  for k = 1:num_targets
    % Target parameters
    R = target(k).R;          % Range in meters
    V = target(k).V;          % Velocity in m/s
    A = target(k).A;          % Amplitude
    RTT = target(k).RTT;      % Round Trip Time
    f_beat = s * RTT;
    % Doppler frequency
    f_d = 2 * V / lambda;
    % Create beat signal
    beat_signal = A * exp(1j * 2*pi * (f_beat * t_fast + f_d * (m-1) * PRI));
    % Add to RX signal
    rx_sig(:, m) = rx_sig(:, m) + beat_signal;
    if m == 1
      rx_chirp(:, m) = rx_chirp(:, m) + beat_signal;
    end
  end
end

%% Adding Gaussian Noise
signal_power = mean(abs(rx_sig(:)).^2);
noise_power = signal_power / SNR_lin;   % SNR_lin calculated in radar_param

noise = sqrt(noise_power/2) * (randn(size(rx_sig)) + 1j*randn(size(rx_sig)));
rx_sig = rx_sig + noise;                % Add noise to the signal

rx_chirp = rx_chirp + noise(:,1);

fprintf('RX signal size with noise: [%d x %d]\n', size(rx_sig));
fprintf('SNR: %.1f dB\n', SNR_dB);
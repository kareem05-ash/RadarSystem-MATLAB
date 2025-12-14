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

%% 3. RX SIGNAL GENERATION
%% =========================================================================
fprintf('\n========== RX SIGNAL GENERATION ==========\n');

num_targets = length(target);
rx_sig = zeros(Nfast, N);

for m = 1:N
    % Total time = fast time + slow time
    t_total = t_fast + (m-1)*PRI;
    
    for k = 1:num_targets
        % Target parameters
        tau = target(k).RTT;     % Round-trip delay
        fd  = target(k).fd;      % Doppler frequency
        A   = target(k).A;       % Amplitude
        
        % Delayed time
        t_delayed = t_fast - tau;
        
        % RTT-delayed FMCW chirp
        rx_chirp = A * exp(1j * 2*pi * ...
            (fmin * t_delayed + 0.5 * s * t_delayed.^2));
        
        % Enforce causality
        rx_chirp(t_delayed < 0) = 0;
        
        % Doppler phase shift (slow time)
        doppler_phase = exp(1j * 2*pi * fd * (m-1)*PRI);
        
        % Add this target contribution
        rx_sig(:,m) = rx_sig(:,m) + rx_chirp * doppler_phase;
    end
end

%% Add AWGN Noise
signal_power = mean(abs(rx_sig(:)).^2);
noise_power  = signal_power / SNR_lin;
noise = sqrt(noise_power/2) * ...
    (randn(size(rx_sig)) + 1j*randn(size(rx_sig)));
rx_sig = rx_sig + noise;

fprintf('RX signal size: [%d x %d]\n', size(rx_sig));

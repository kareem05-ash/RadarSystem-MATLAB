%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 5. Slow-Axis FFT (FDoppler detection)
%% =========================================================================
[~, max_range_bin] = max(range_fft_mag_half);
range_bin_idx = max_range_bin;
slow_time_signal = rx_sig(range_bin_idx, :);

window_doppler = hamming(N);
windowed_slow = slow_time_signal(:) .* window_doppler;

% Apply FFT (to get fD)
doppler_fft = fft(windowed_slow, N);
doppler_fft_mag = abs(doppler_fft);

% Centerlized around zero
doppler_fft_mag_shifted = fftshift(doppler_fft_mag);

doppler_freq = (-N/2 : N/2-1) * (PRF / N);      % Doppler Frequency Axis
velocity = (lambda * doppler_freq) / 2;         % Velocity axis
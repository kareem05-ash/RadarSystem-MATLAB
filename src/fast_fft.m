%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 4. Fast-Axis FFT (Fbeat detection)
%% =========================================================================

first_chirp = rx_sig(:, 1);     % Taking only the firts column
window_range = hamming(Nfast);
windowed_chirp = first_chirp .* window_range;

% Apply FFT
range_fft = fft(windowed_chirp, Nfast);
range_fft_mag = abs(range_fft);

fbeat = (0 : Nfast-1) * (fs / Nfast);     % Beat Frequency Axis
R_fft = (c * Tch * fbeat) / (2 * Bw);     % Range Axis

% taking first half positive frequencies
Nhalf = floor(Nfast/2);
fbeat_half = fbeat(1 : Nhalf);
R_fft_half = R_fft(1 : Nhalf);
range_fft_mag_half = range_fft_mag(1 : Nhalf);
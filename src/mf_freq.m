%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

%% Frequency-Domain Matched Filter
% Performs matched filtering using FFT (fast & practical)

% %% Load Parameters & RX
% run radar_param;
% run rx_gen;

%% -------------------------
%% FFT of TX Chirp (Matched Filter)
%% -------------------------
H = fft(conj(tx_chirp), Nfast);   % Frequency response of MF

%% -------------------------
%% Apply MF using FFT
%% -------------------------
mf_out_freq = zeros(Nfast, N);

for n = 1:N
  R = fft(rx_fast(:,n), Nfast);
  Y = R .* H;
  mf_out_freq(:,n) = ifft(Y);
end

%% -------------------------
%% Range Axis
%% -------------------------
range_axis = (0:Nfast-1).' * (c / (2 * fs));

%% =========================
%% Summary
%% =========================
fprintf('\n======= Frequency-Domain MF Completed =======\n');
fprintf(' > Output size = [%d x %d]\n', size(mf_out_freq));
fprintf('============================================\n\n');
%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

%% Frequency-Domain Matched Filter
% Performs matched filtering using FFT (fast & practical)

% %% Load Parameters & RX
% run radar_param;
% run rx_gen;

%% 4. MATCHED FILTER (FREQUENCY DOMAIN)
%% =========================================================================
fprintf('\n========== MATCHED FILTERING ==========\n');

H = fft(conj(tx_chirp), Nfast);   % Frequency response of matched filter
mf_out = zeros(Nfast, N);

for n = 1:N
    R = fft(rx_sig(:,n), Nfast);
    Y = R .* H;
    mf_out(:,n) = ifft(Y);
end

fprintf('Matched filter output size: [%d x %d]\n', size(mf_out));
%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

%% Time-Domain Matched Filter
% Performs matched filtering using convolution (time domain)

% %% Load Parameters & RX
% run radar_param;
% run rx_gen;

%% -------------------------
%% Matched Filter Impulse Response
%% -------------------------
h_mf = conj(flipud(tx_chirp));   % s*(-t)

%% -------------------------
%% Apply Matched Filter (Pulse-by-Pulse)
%% -------------------------
mf_out_time = zeros(Nfast, N);

for n = 1:N
  y = conv(rx_fast(:,n), h_mf, 'same');
  mf_out_time(:,n) = y;
end

%% -------------------------
%% Range Axis
%% -------------------------
range_axis = (0:Nfast-1).' * (c / (2 * fs));

%% =========================
%% Summary
%% =========================
fprintf('\n======= Time-Domain MF Completed =======\n');
fprintf(' > Output size = [%d x %d]\n', size(mf_out_time));
fprintf('========================================\n\n');
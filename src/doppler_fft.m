%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% https://github.com/kareem05-ash

%% Doppler FFT Processing
% Performs FFT along slow-time axis (pulse dimension)

% %% Load MF output
% run radar_param;
% run mf_freq;   % أو mf_time (النتيجة واحدة)

%% -------------------------
%% Doppler FFT
%% -------------------------
RD_map = fftshift(fft(mf_out_freq, N, 2), 2);  % FFT along pulses

%% -------------------------
%% Axes
%% -------------------------
range_axis = (0:Nfast-1).' * (c / (2*fs));

fd_axis = (-N/2:N/2-1) * (PRF/N);
vel_axis = (fd_axis * lambda) / 2;

%% =========================
%% Summary
%% =========================
fprintf('\n======= Doppler FFT Completed =======\n');
fprintf(' > RD map size = [%d x %d]\n', size(RD_map));
fprintf('====================================\n\n');
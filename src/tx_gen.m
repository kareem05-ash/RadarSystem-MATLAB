%% Signature
% Kareem Ashraf Mostafa
% kareem.ash05@gmail.com
% +201002321067
% https://github.com/kareem05-ash

%% TX Transmision Line
% This script generates:
%   1) Baseband LFM Chirp
%   2) Pulse Train
%   3) 2D Data Matrix (Nfast x N)
%   4) Continuous time-domain signal

%% Load Radar Parameters
run radar_param;

%% -------------------------
%% Fast-Time Axis & LFM Chirp
%% -------------------------
t_fast = (0 : Nfast-1).' * Ts;      % Column Vector [Nfast x 1]
tx_chirp = exp(1j * pi * slope .* (t_fast.^2));   % Chirp
tx_pulse = zeros(Npri, 1);          % Samples over complete PRI
tx_pulse(1 : Nfast) = tx_chirp;

%% -------------------------
%% Slow-Time Axis (pulse index)
%% -------------------------
n_pulse = 0:N-1;                    % Pulse Indecies
t_slow = n_pulse * PRI;             % Slow-Time Axis (multiples of PRI)

%% -------------------------
%% Pulse Train (2D Matrix) for processing
%% -------------------------
tx_mat = repmat(tx_pulse, 1, N);    % [Npri x N] matrix

%% -------------------------
%% Continuous Time
%% -------------------------
tx_cont = tx_mat(:);                % continuous data vector (One Dimension)
t_total = (0:length(tx_cont)-1)'*Ts;% continuous time vector over all pulses

%% =========================
%% TX Summary
%% =========================
fprintf('\n=============== TX Generation Summary ===============\n');
fprintf(' > Total Samples = %d\n', length(tx_cont));
fprintf('\n========================================================\n\n');






% %% -------------------------
% %% Continuous Time (Radar-Accurate)
% %% -------------------------
% Ns_PRI = round(PRI / Ts);          % Samples per PRI
% tx_pri = zeros(Ns_PRI, 1);
% tx_pri(1:Nfast) = tx_chirp;        % Chirp + idle time

% tx_cont = repmat(tx_pri, N, 1);    % Continuous TX signal
% t_total = (0:length(tx_cont)-1).' * Ts;

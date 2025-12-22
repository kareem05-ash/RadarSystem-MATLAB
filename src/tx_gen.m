%% Kareem Ashraf Mostafa
%  kareem.ash05@gmail.com
%  github.com/kareem05-ash

%% =========================================================================
%% 2. TX SIGNAL GENERATION
%% =========================================================================
fprintf('\n========== TX SIGNAL GENERATION ==========\n');
t_fast_plt = 0 : Ts : Tch;
t_fast = (0 : Nfast - 1).' * Ts;          % [Nfast x 1] fast time vector
tx_chirp_plt = exp(1j * 2*pi * (fmin * t_fast_plt + 0.5 * s * t_fast_plt.^2));
tx_chirp = exp(1j * 2*pi * (fmin * t_fast_plt + 0.5 * s * t_fast_plt.^2));
tx_sig = repmat(tx_chirp, 1, N);          % [Nfast x N] data matrix

fprintf('TX signal size: [%d x %d]\n', size(tx_sig));
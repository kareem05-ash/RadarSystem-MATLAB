function R_sig = generate_received_signal(P_t, Target, radar_params)
% GENERATE_RECEIVED_SIGNAL: Generates the 2D received signal matrix (Range samples x N_pulses).
%
% Inputs:
%   P_t:            Transmitted LFM pulse vector (1D)
%   Target:         Structure array containing target parameters (R, v, tau, Fd)
%   radar_params:   Structure/Variables containing essential parameters (c, Fc, PRI, N_pulses, N_fast_time, Ts, SNR_dB)
%
% Output:
%   R_sig:          Complex received signal matrix (N_fast_time x N_pulses)

% Extract parameters
c = radar_params.c;
Fc = radar_params.Fc;
PRI = radar_params.PRI;
N_pulses = radar_params.N_pulses;
N_fast_time = radar_params.N_fast_time;
Ts = radar_params.Ts;
SNR_dB = radar_params.SNR_dB;
num_targets = length(Target);

R_sig = zeros(N_fast_time, N_pulses);
P_t_col = P_t(:); % Column vector for transmitted pulse

% Time vector for phase calculation (t = 0, Ts, 2Ts, ...)
% Note: We use 0:N_pulses-1 for the pulse index 'n'
t_fast = (0:N_fast_time-1) * Ts; 

% Loop over all pulses (Slow-Time Axis)
for n = 0:N_pulses-1 
    current_pulse_echo = zeros(N_fast_time, 1);
    
    % Loop over all targets
    for l = 1:num_targets
        tau_l = Target(l).tau;      % Time delay (2R/c)
        Fd_l = Target(l).Fd;        % Doppler frequency shift
        
        % 1. Time Delay: Shift the transmitted pulse
        delay_samples = round(tau_l / Ts);
        
        % Shift P_t_col by padding with zeros at the start
        P_delayed = [zeros(delay_samples, 1); P_t_col(1:end-delay_samples)];
        % Truncate to N_fast_time length
        P_delayed = P_delayed(1:N_fast_time); 
        
        % 2. Doppler Phase Accumulation (Across pulses): phi[n] = 2*pi*Fd*n*PRI
        phi_n = 2 * pi * Fd_l * n * PRI;
        
        % Received echo = Delayed Pulse * Doppler Phase Factor
        target_echo = P_delayed .* exp(-1j * phi_n); 
        
        % Sum the target echoes
        current_pulse_echo = current_pulse_echo + target_echo;
    end
    
    % 3. Add AWGN (Ensure this function is implemented in utils/add_awgn.m)
    R_sig(:, n+1) = add_awgn(current_pulse_echo, SNR_dB);
end

end

% --- utils/add_awgn.m (Helper function) ---
function y_noisy = add_awgn(x, SNR_dB)
    Px = sum(abs(x).^2) / length(x);
    SNR_linear = 10^(SNR_dB / 10);
    Pn = Px / SNR_linear;
    sigma = sqrt(Pn/2);
    noise = sigma * (randn(size(x)) + 1j * randn(size(x)));
    y_noisy = x + noise;
end
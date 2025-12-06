function P_t = generate_transmitted_pulse(S, Tp, Ts, N_fast_time)

% 1. Create the time vector (Fast-Time Axis) over the PRI duration
t = (0:N_fast_time-1) * Ts;

% 2. Generate the LFM signal (Baseband)
P_t = exp(1j * pi * S * t.^2);

% 3. Apply the Pulse Window (u(t) - u(t - Tp))
pulse_indices = (t >= 0) & (t < Tp);

% Ensure the pulse is zero outside the pulse width
P_t(~pulse_indices) = 0;

% FIX: ÞÕ P_t áÖãÇä Ãä Øæáå åæ N_fast_time ÈÇáÖÈØ
P_t = P_t(1:N_fast_time); 
P_t = P_t(:); % ÖãÇä Ãäå ÚãæÏ vector

end
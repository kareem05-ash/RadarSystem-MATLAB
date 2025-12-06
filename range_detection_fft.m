function range_compress_sig_fft = range_detection_fft(R_sig, P_t)
% ... ( ⁄—Ì›«  Ê√»⁄«œ) ...

% 1. Determine the optimal FFT size (for linear convolution equivalent)
N_fft = 2^nextpow2(N_fast_time + N_P_t - 1); 

% 2. Calculate the Matched Filter Spectrum H(f)
% FIX: ÌÃ» √‰ Ì „ Õ”«» P_t_fft Â‰«:
P_t_fft = fft(P_t(:), N_fft); 

H_fft = conj(P_t_fft); 

% 3. Initialize the output matrix (N_fft x N_pulses)
% ... (»«ﬁÌ «·ﬂÊœ) ...

% Apply Matched Filtering column-wise
for n = 1:N_pulses
    R_sig_fft = fft(R_sig(:, n), N_fft);
    Y_fft = R_sig_fft .* H_fft; 
    range_compress_sig_fft(:, n) = ifft(Y_fft);
end

end